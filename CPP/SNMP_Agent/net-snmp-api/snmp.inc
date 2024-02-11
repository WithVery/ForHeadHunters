#include <net-snmp/library/int64.h>
#include <net-snmp/library/tools.h>
#include <net-snmp/library/parse.h>
#include <net-snmp/library/read_config.h>
//#include <config.h>
#include <net-snmp/library/asn1.h>
#include <net-snmp/library/snmp_assert.h>
#include <net-snmp/library/mt_support.h>
#include <net-snmp/library/snmp_secmod.h>
#include <net-snmp/library/snmp_api.h>

enum inet_address_type {
    IPV4 = 1,
    IPV6 = 2,
    IPV4Z = 3,
    IPV6Z = 4,
    DNS = 16
};

static char    *confmibdir = NULL;
static char    *confmibs = NULL;

static char     snmp_detail[192];
static int      snmp_detail_f = 0;
 
struct session_list *Sessions = NULL;   /* MT_LIB_SESSION */
static long     Reqid = 0;      /* MT_LIB_REQUESTID */
static long     Msgid = 0;      /* MT_LIB_MESSAGEID */
static long     Sessid = 0;     /* MT_LIB_SESSIONID */
static long     Transid = 0;    /* MT_LIB_TRANSID */
//int             snmp_errno = 0; 

static oid      default_enterprise[] = { 1, 3, 6, 1, 4, 1, 3, 1, 1 };

static mutex_type s_res[MT_MAX_IDS][MT_LIB_MAXIMUM];  /* locking structures */ 

static netsnmp_tdomain *domain_list = NULL; 
oid             netsnmpUDPDomain[] = { 1, 3, 6, 1, 6, 1, 1 };
size_t          netsnmpUDPDomain_len = OID_LENGTH(netsnmpUDPDomain); 
/*
 * enterprises.cmu.systems.cmuSNMP 
 */

#define DEFAULT_COMMUNITY   "public"
#define DEFAULT_RETRIES	    5
#define DEFAULT_TIMEOUT	    ONE_SEC
#define DEFAULT_REMPORT	    SNMP_PORT
#define DEFAULT_ENTERPRISE  default_enterprise
#define DEFAULT_TIME	    0 

#define NETSNMP_DEFAULT_MIBDIRS ""

/*
 * Internal information about the state of the snmp session.
 */
struct snmp_internal_session {
    netsnmp_request_list *requests;     /* Info about outstanding requests */
    netsnmp_request_list *requestsEnd;  /* ptr to end of list */
    int             (*hook_pre) (netsnmp_session *, netsnmp_transport *,
                                 void *, int);
    int             (*hook_parse) (netsnmp_session *, netsnmp_pdu *,
                                   u_char *, size_t);
    int             (*hook_post) (netsnmp_session *, netsnmp_pdu *, int);
    int             (*hook_build) (netsnmp_session *, netsnmp_pdu *,
                                   u_char *, size_t *);
    int             (*hook_realloc_build) (netsnmp_session *,
                                           netsnmp_pdu *, u_char **,
                                           size_t *, size_t *);
    int             (*check_packet) (u_char *, size_t);
    netsnmp_pdu    *(*hook_create_pdu) (netsnmp_transport *,
                                        void *, size_t);

    u_char         *packet;
    size_t          packet_len, packet_size;
}; 

netsnmp_pdu* snmp_pdu_create(int command) {
  netsnmp_pdu    *pdu;
  pdu = (netsnmp_pdu *) calloc(1, sizeof(netsnmp_pdu));
  if (pdu) {
    pdu->version = 	SNMP_VERSION_2c; //SNMP_DEFAULT_VERSION;
    pdu->command = command;
    pdu->errstat = SNMP_DEFAULT_ERRSTAT;
    pdu->errindex = SNMP_DEFAULT_ERRINDEX;
    pdu->securityModel = SNMP_DEFAULT_SECMODEL;
    pdu->transport_data = NULL;
    pdu->transport_data_length = 0;
    pdu->securityNameLen = 0;
    pdu->contextNameLen = 0;
    pdu->time = 0;
    pdu->reqid = 1458; // snmp_get_next_reqid();
    pdu->msgid = 4475; // snmp_get_next_msgid();
  }
  return pdu;

}

static char    *uptimeString(u_long, char *, size_t);

int snmp_log(int priority, const char *format, ...) {
/*
    va_list         ap;
    int             ret;
    va_start(ap, format);
    ret = snmp_vlog(priority, format, ap);
    va_end(ap);
    return (ret);
*/
    return (0);
} 

/*
 * log a critical error.
 */
void snmp_log_perror(const char *s) {
    char           *error = strerror(errno);
    if (s) {
        if (error)
            snmp_log(LOG_ERR, "%s: %s\n", s, error);
        else
            snmp_log(LOG_ERR, "%s: Error %d out-of-range\n", s, errno);
    } else {
        if (error)
            snmp_log(LOG_ERR, "%s\n", error);
        else
            snmp_log(LOG_ERR, "Error %d out-of-range\n", errno);
    }
} 

static int      translation_table[256];
 

#define SYNTAX_MASK     0x80
/*
 * types of tokens
 * Tokens wiht the SYNTAX_MASK bit set are syntax tokens 
 */
#define CONTINUE    -1
#define ENDOFFILE   0
#define LABEL       1
#define SUBTREE     2
#define SYNTAX      3
#define OBJID       (4 | SYNTAX_MASK)
#define OCTETSTR    (5 | SYNTAX_MASK)
#define INTEGER     (6 | SYNTAX_MASK)
#define NETADDR     (7 | SYNTAX_MASK)
#define IPADDR      (8 | SYNTAX_MASK)
#define COUNTER     (9 | SYNTAX_MASK)
#define GAUGE       (10 | SYNTAX_MASK)
#define TIMETICKS   (11 | SYNTAX_MASK)
#define KW_OPAQUE   (12 | SYNTAX_MASK)
#define NUL         (13 | SYNTAX_MASK)
#define SEQUENCE    14
#define OF          15          /* SEQUENCE OF */
#define OBJTYPE     16
#define ACCESS      17
#define READONLY    18
#define READWRITE   19
#define WRITEONLY   20
#ifdef NOACCESS
#undef NOACCESS                 /* agent 'NOACCESS' token */
#endif
#define NOACCESS    21
#define STATUS      22
#define MANDATORY   23
#define KW_OPTIONAL    24
#define OBSOLETE    25
/*
 * #define RECOMMENDED 26 
 */
#define PUNCT       27
#define EQUALS      28
#define NUMBER      29
#define LEFTBRACKET 30
#define RIGHTBRACKET 31
#define LEFTPAREN   32
#define RIGHTPAREN  33
#define COMMA       34
#define DESCRIPTION 35
#define QUOTESTRING 36
#define INDEX       37
#define DEFVAL      38
#define DEPRECATED  39
#define SIZE        40
#define BITSTRING   (41 | SYNTAX_MASK)
#define NSAPADDRESS (42 | SYNTAX_MASK)
#define COUNTER64   (43 | SYNTAX_MASK)
#define OBJGROUP    44
#define NOTIFTYPE   45
#define AUGMENTS    46
#define COMPLIANCE  47
#define READCREATE  48
#define UNITS       49
#define REFERENCE   50
#define NUM_ENTRIES 51
#define MODULEIDENTITY 52
#define LASTUPDATED 53
#define ORGANIZATION 54
#define CONTACTINFO 55
#define UINTEGER32 (56 | SYNTAX_MASK)
#define CURRENT     57
#define DEFINITIONS 58
#define END         59
#define SEMI        60
#define TRAPTYPE    61
#define ENTERPRISE  62
/*
 * #define DISPLAYSTR (63 | SYNTAX_MASK) 
 */
#define BEGIN       64
#define IMPORTS     65
#define EXPORTS     66
#define ACCNOTIFY   67
#define BAR         68
#define RANGE       69
#define CONVENTION  70
#define DISPLAYHINT 71
#define FROM        72
#define AGENTCAP    73
#define MACRO       74
#define IMPLIED     75
#define SUPPORTS    76
#define INCLUDES    77
#define VARIATION   78
#define REVISION    79
#define NOTIMPL	    80
#define OBJECTS	    81
#define NOTIFICATIONS	82
#define MODULE	    83
#define MINACCESS   84
#define PRODREL	    85
#define WRSYNTAX    86
#define CREATEREQ   87
#define NOTIFGROUP  88
#define MANDATORYGROUPS	89
#define GROUP	    90
#define OBJECT	    91
#define IDENTIFIER  92
#define CHOICE	    93
#define LEFTSQBRACK	95
#define RIGHTSQBRACK	96
#define IMPLICIT    97
#define APPSYNTAX	(98 | SYNTAX_MASK)
#define OBJSYNTAX	(99 | SYNTAX_MASK)
#define SIMPLESYNTAX	(100 | SYNTAX_MASK)
#define OBJNAME		(101 | SYNTAX_MASK)
#define NOTIFNAME	(102 | SYNTAX_MASK)
#define VARIABLES	103
#define UNSIGNED32	(104 | SYNTAX_MASK)
#define INTEGER32	(105 | SYNTAX_MASK)
#define OBJIDENTITY	106
/*
 * Beware of reaching SYNTAX_MASK (0x80) 
 */
static struct node *orphan_nodes = NULL; 

struct tok {
    const char     *name;       /* token name */
    int             len;        /* length not counting nul */
    int             token;      /* value */
    int             hash;       /* hash of name */
    struct tok     *next;       /* pointer to next in hash table */
};


static struct tok tokens[] = {
    {"obsolete", sizeof("obsolete") - 1, OBSOLETE}
    ,
    {"Opaque", sizeof("Opaque") - 1, KW_OPAQUE}
    ,
    {"optional", sizeof("optional") - 1, KW_OPTIONAL}
    ,
    {"LAST-UPDATED", sizeof("LAST-UPDATED") - 1, LASTUPDATED}
    ,
    {"ORGANIZATION", sizeof("ORGANIZATION") - 1, ORGANIZATION}
    ,
    {"CONTACT-INFO", sizeof("CONTACT-INFO") - 1, CONTACTINFO}
    ,
    {"MODULE-IDENTITY", sizeof("MODULE-IDENTITY") - 1, MODULEIDENTITY}
    ,
    {"MODULE-COMPLIANCE", sizeof("MODULE-COMPLIANCE") - 1, COMPLIANCE}
    ,
    {"DEFINITIONS", sizeof("DEFINITIONS") - 1, DEFINITIONS}
    ,
    {"END", sizeof("END") - 1, END}
    ,
    {"AUGMENTS", sizeof("AUGMENTS") - 1, AUGMENTS}
    ,
    {"not-accessible", sizeof("not-accessible") - 1, NOACCESS}
    ,
    {"write-only", sizeof("write-only") - 1, WRITEONLY}
    ,
    {"NsapAddress", sizeof("NsapAddress") - 1, NSAPADDRESS}
    ,
    {"UNITS", sizeof("Units") - 1, UNITS}
    ,
    {"REFERENCE", sizeof("REFERENCE") - 1, REFERENCE}
    ,
    {"NUM-ENTRIES", sizeof("NUM-ENTRIES") - 1, NUM_ENTRIES}
    ,
    {"BITSTRING", sizeof("BITSTRING") - 1, BITSTRING}
    ,
    {"BIT", sizeof("BIT") - 1, CONTINUE}
    ,
    {"BITS", sizeof("BITS") - 1, BITSTRING}
    ,
    {"Counter64", sizeof("Counter64") - 1, COUNTER64}
    ,
    {"TimeTicks", sizeof("TimeTicks") - 1, TIMETICKS}
    ,
    {"NOTIFICATION-TYPE", sizeof("NOTIFICATION-TYPE") - 1, NOTIFTYPE}
    ,
    {"OBJECT-GROUP", sizeof("OBJECT-GROUP") - 1, OBJGROUP}
    ,
    {"OBJECT-IDENTITY", sizeof("OBJECT-IDENTITY") - 1, OBJIDENTITY}
    ,
    {"IDENTIFIER", sizeof("IDENTIFIER") - 1, IDENTIFIER}
    ,
    {"OBJECT", sizeof("OBJECT") - 1, OBJECT}
    ,
    {"NetworkAddress", sizeof("NetworkAddress") - 1, NETADDR}
    ,
    {"Gauge", sizeof("Gauge") - 1, GAUGE}
    ,
    {"Gauge32", sizeof("Gauge32") - 1, GAUGE}
    ,
    {"Unsigned32", sizeof("Unsigned32") - 1, UNSIGNED32}
    ,
    {"read-write", sizeof("read-write") - 1, READWRITE}
    ,
    {"read-create", sizeof("read-create") - 1, READCREATE}
    ,
    {"OCTETSTRING", sizeof("OCTETSTRING") - 1, OCTETSTR}
    ,
    {"OCTET", sizeof("OCTET") - 1, CONTINUE}
    ,
    {"OF", sizeof("OF") - 1, OF}
    ,
    {"SEQUENCE", sizeof("SEQUENCE") - 1, SEQUENCE}
    ,
    {"NULL", sizeof("NULL") - 1, NUL}
    ,
    {"IpAddress", sizeof("IpAddress") - 1, IPADDR}
    ,
    {"UInteger32", sizeof("UInteger32") - 1, UINTEGER32}
    ,
    {"INTEGER", sizeof("INTEGER") - 1, INTEGER}
    ,
    {"Integer32", sizeof("Integer32") - 1, INTEGER32}
    ,
    {"Counter", sizeof("Counter") - 1, COUNTER}
    ,
    {"Counter32", sizeof("Counter32") - 1, COUNTER}
    ,
    {"read-only", sizeof("read-only") - 1, READONLY}
    ,
    {"DESCRIPTION", sizeof("DESCRIPTION") - 1, DESCRIPTION}
    ,
    {"INDEX", sizeof("INDEX") - 1, INDEX}
    ,
    {"DEFVAL", sizeof("DEFVAL") - 1, DEFVAL}
    ,
    {"deprecated", sizeof("deprecated") - 1, DEPRECATED}
    ,
    {"SIZE", sizeof("SIZE") - 1, SIZE}
    ,
    {"MAX-ACCESS", sizeof("MAX-ACCESS") - 1, ACCESS}
    ,
    {"ACCESS", sizeof("ACCESS") - 1, ACCESS}
    ,
    {"mandatory", sizeof("mandatory") - 1, MANDATORY}
    ,
    {"current", sizeof("current") - 1, CURRENT}
    ,
    {"STATUS", sizeof("STATUS") - 1, STATUS}
    ,
    {"SYNTAX", sizeof("SYNTAX") - 1, SYNTAX}
    ,
    {"OBJECT-TYPE", sizeof("OBJECT-TYPE") - 1, OBJTYPE}
    ,
    {"TRAP-TYPE", sizeof("TRAP-TYPE") - 1, TRAPTYPE}
    ,
    {"ENTERPRISE", sizeof("ENTERPRISE") - 1, ENTERPRISE}
    ,
    {"BEGIN", sizeof("BEGIN") - 1, BEGIN}
    ,
    {"IMPORTS", sizeof("IMPORTS") - 1, IMPORTS}
    ,
    {"EXPORTS", sizeof("EXPORTS") - 1, EXPORTS}
    ,
    {"accessible-for-notify", sizeof("accessible-for-notify") - 1,
     ACCNOTIFY}
    ,
    {"TEXTUAL-CONVENTION", sizeof("TEXTUAL-CONVENTION") - 1, CONVENTION}
    ,
    {"NOTIFICATION-GROUP", sizeof("NOTIFICATION-GROUP") - 1, NOTIFGROUP}
    ,
    {"DISPLAY-HINT", sizeof("DISPLAY-HINT") - 1, DISPLAYHINT}
    ,
    {"FROM", sizeof("FROM") - 1, FROM}
    ,
    {"AGENT-CAPABILITIES", sizeof("AGENT-CAPABILITIES") - 1, AGENTCAP}
    ,
    {"MACRO", sizeof("MACRO") - 1, MACRO}
    ,
    {"IMPLIED", sizeof("IMPLIED") - 1, IMPLIED}
    ,
    {"SUPPORTS", sizeof("SUPPORTS") - 1, SUPPORTS}
    ,
    {"INCLUDES", sizeof("INCLUDES") - 1, INCLUDES}
    ,
    {"VARIATION", sizeof("VARIATION") - 1, VARIATION}
    ,
    {"REVISION", sizeof("REVISION") - 1, REVISION}
    ,
    {"not-implemented", sizeof("not-implemented") - 1, NOTIMPL}
    ,
    {"OBJECTS", sizeof("OBJECTS") - 1, OBJECTS}
    ,
    {"NOTIFICATIONS", sizeof("NOTIFICATIONS") - 1, NOTIFICATIONS}
    ,
    {"MODULE", sizeof("MODULE") - 1, MODULE}
    ,
    {"MIN-ACCESS", sizeof("MIN-ACCESS") - 1, MINACCESS}
    ,
    {"PRODUCT-RELEASE", sizeof("PRODUCT-RELEASE") - 1, PRODREL}
    ,
    {"WRITE-SYNTAX", sizeof("WRITE-SYNTAX") - 1, WRSYNTAX}
    ,
    {"CREATION-REQUIRES", sizeof("CREATION-REQUIRES") - 1, CREATEREQ}
    ,
    {"MANDATORY-GROUPS", sizeof("MANDATORY-GROUPS") - 1, MANDATORYGROUPS}
    ,
    {"GROUP", sizeof("GROUP") - 1, GROUP}
    ,
    {"CHOICE", sizeof("CHOICE") - 1, CHOICE}
    ,
    {"IMPLICIT", sizeof("IMPLICIT") - 1, IMPLICIT}
    ,
    {"ObjectSyntax", sizeof("ObjectSyntax") - 1, OBJSYNTAX}
    ,
    {"SimpleSyntax", sizeof("SimpleSyntax") - 1, SIMPLESYNTAX}
    ,
    {"ApplicationSyntax", sizeof("ApplicationSyntax") - 1, APPSYNTAX}
    ,
    {"ObjectName", sizeof("ObjectName") - 1, OBJNAME}
    ,
    {"NotificationName", sizeof("NotificationName") - 1, NOTIFNAME}
    ,
    {"VARIABLES", sizeof("VARIABLES") - 1, VARIABLES}
    ,
    {NULL}
};

static struct module_compatability *module_map_head;
static struct module_compatability module_map[] = {
    {"RFC1065-SMI", "RFC1155-SMI", NULL, 0},
    {"RFC1066-MIB", "RFC1156-MIB", NULL, 0},
    /*
     * 'mib' -> 'mib-2' 
     */
    {"RFC1156-MIB", "RFC1158-MIB", NULL, 0},
    /*
     * 'snmpEnableAuthTraps' -> 'snmpEnableAuthenTraps' 
     */
    {"RFC1158-MIB", "RFC1213-MIB", NULL, 0},
    /*
     * 'nullOID' -> 'zeroDotZero' 
     */
    {"RFC1155-SMI", "SNMPv2-SMI", NULL, 0},
    {"RFC1213-MIB", "SNMPv2-SMI", "mib-2", 0},
    {"RFC1213-MIB", "SNMPv2-MIB", "sys", 3},
    {"RFC1213-MIB", "IF-MIB", "if", 2},
    {"RFC1213-MIB", "IP-MIB", "ip", 2},
    {"RFC1213-MIB", "IP-MIB", "icmp", 4},
    {"RFC1213-MIB", "TCP-MIB", "tcp", 3},
    {"RFC1213-MIB", "UDP-MIB", "udp", 3},
    {"RFC1213-MIB", "SNMPv2-SMI", "transmission", 0},
    {"RFC1213-MIB", "SNMPv2-MIB", "snmp", 4},
    {"RFC1231-MIB", "TOKENRING-MIB", NULL, 0},
    {"RFC1271-MIB", "RMON-MIB", NULL, 0},
    {"RFC1286-MIB", "SOURCE-ROUTING-MIB", "dot1dSr", 7},
    {"RFC1286-MIB", "BRIDGE-MIB", NULL, 0},
    {"RFC1315-MIB", "FRAME-RELAY-DTE-MIB", NULL, 0},
    {"RFC1316-MIB", "CHARACTER-MIB", NULL, 0},
    {"RFC1406-MIB", "DS1-MIB", NULL, 0},
    {"RFC-1213", "RFC1213-MIB", NULL, 0},
}; 
#define NETSNMP_DS_MAX_IDS 3
#define NETSNMP_DS_MAX_SUBIDS 48        /* needs to be a multiple of 8 */ 

#define NETSNMP_DS_LIBRARY_ID     0
#define NETSNMP_DS_APPLICATION_ID 1
#define NETSNMP_DS_TOKEN_ID       2

#define MODULE_NOT_FOUND	0
#define MODULE_LOADED_OK	1
#define MODULE_ALREADY_LOADED	2
/*
 * #define MODULE_LOAD_FAILED   3       
 */
#define MODULE_LOAD_FAILED	MODULE_NOT_FOUND
#define MODULE_SYNTAX_ERROR     4

int gMibError = 0,gLoop = 0;
char *gpMibErrorString = NULL;
char gMibNames[STRINGMAX];
 
#define HASHSIZE        32
#define BUCKET(x)       (x & (HASHSIZE-1))

#define NHASHSIZE    128
#define NBUCKET(x)   (x & (NHASHSIZE-1))
 
static struct tok *buckets[HASHSIZE];
static struct node *nbuckets[NHASHSIZE];
static struct tree *tbuckets[NHASHSIZE]; 
static struct module *module_head = NULL; 

#define	NUMBER_OF_ROOT_NODES	3
static struct module_import root_imports[NUMBER_OF_ROOT_NODES];

static int      current_module = 0;
static int      max_module = 0;
static int      first_err_module = 1;
static char    *last_err_module = NULL; /* no repeats on "Cannot find module..." */ 

#ifdef STRICT_MIB_PARSEING
#define	label_compare	strcasecmp
#else
#define	label_compare	strcmp
#endif 

static int   netsnmp_ds_integers[NETSNMP_DS_MAX_IDS][NETSNMP_DS_MAX_SUBIDS]; 
static char  netsnmp_ds_booleans[NETSNMP_DS_MAX_IDS][NETSNMP_DS_MAX_SUBIDS/8]; 
static char *netsnmp_ds_strings[NETSNMP_DS_MAX_IDS][NETSNMP_DS_MAX_SUBIDS]; 

int netsnmp_ds_get_int(int storeid, int which) {
  if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || which < 0 || which >= NETSNMP_DS_MAX_SUBIDS) {
      return SNMPERR_GENERR;
  }
  return netsnmp_ds_integers[storeid][which];
} 
char *netsnmp_ds_get_string(int storeid, int which) {
    if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || 
	which   < 0 || which   >= NETSNMP_DS_MAX_SUBIDS) {
        return NULL;
    }

    return netsnmp_ds_strings[storeid][which];
} 

int netsnmp_ds_set_string(int storeid, int which, const char *value) {
    if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || 
	which   < 0 || which   >= NETSNMP_DS_MAX_SUBIDS) {
        return SNMPERR_GENERR;
    }

//    DEBUGMSGTL(("netsnmp_ds_set_string", "Setting %s:%d = \"%s\"\n", stores[storeid], which, (value ? value : "(null)")));

    /*
     * is some silly person is calling us with our own pointer?
     */
    if (netsnmp_ds_strings[storeid][which] == value)
        return SNMPERR_SUCCESS;
    
    if (netsnmp_ds_strings[storeid][which] != NULL) {
        free(netsnmp_ds_strings[storeid][which]);
	netsnmp_ds_strings[storeid][which] = NULL;
    }

    if (value) {
        netsnmp_ds_strings[storeid][which] = strdup(value);
    } else {
        netsnmp_ds_strings[storeid][which] = NULL;
    }

    return SNMPERR_SUCCESS;
} 

int             mibLine = 0;
const char     *File = "(none)";
static int      anonymous = 0;

struct objgroup {
    char           *name;
    int             line;
    struct objgroup *next;
}              *objgroups = NULL, *objects = NULL, *notifs = NULL; 

/*
 * A linked list of nodes.
 */
struct node {
    struct node    *next;
    char           *label;  /* This node's (unique) textual name */
    u_long          subid;  /* This node's integer subidentifier */
    int             modid;  /* The module containing this node */
    char           *parent; /* The parent's textual name */
    int             tc_index; /* index into tclist (-1 if NA) */
    int             type;   /* The type of object this represents */
    int             access;
    int             status;
    struct enum_list *enums; /* (optional) list of enumerated integers */
    struct range_list *ranges;
    struct index_list *indexes;
    char           *augments;
    struct varbind_list *varbinds;
    char           *hint;
    char           *units;
    char           *description; /* description (a quoted string) */
    char           *reference; /* references (a quoted string) */
    char           *defaultValue;
    char           *filename;
    int             lineno;
};
  
/*
 * This is one element of an object identifier with either an integer
 * subidentifier, or a textual string label, or both.
 * The subid is -1 if not present, and label is NULL if not present.
 */
struct subid_s {
    int             subid;
    int             modid;
    char           *label;
}; 

#define MAXTC   4096
struct tc {                     /* textual conventions */
    int             type;
    int             modid;
    char           *descriptor;
    char           *hint;
    struct enum_list *enums;
    struct range_list *ranges;
    char           *description;
} tclist[MAXTC];
 
static int name_hash(const char *name) {
    int             hash = 0;
    const char     *cp;

    if (!name)
        return 0;
    for (cp = name; *cp; cp++)
        hash += tolower((unsigned char)(*cp));
    return (hash);
}
 
node *parse(FILE *, struct node *); 

int netsnmp_ds_get_boolean(int storeid, int which) {
    if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || which   < 0 || which   >= NETSNMP_DS_MAX_SUBIDS) {
        return SNMPERR_GENERR;
    }
    return (netsnmp_ds_booleans[storeid][which/8] & (1 << (which % 8))) ? 1:0;
} 

int netsnmp_ds_set_boolean(int storeid, int which, int value) {
    if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || which   < 0 || which   >= NETSNMP_DS_MAX_SUBIDS) {
        return SNMPERR_GENERR;
    }

//    DEBUGMSGTL(("netsnmp_ds_set_boolean", "Setting %s:%d = %d/%s\n", stores[storeid], which, value, ((value) ? "True" : "False")));

    if (value > 0) {
        netsnmp_ds_booleans[storeid][which/8] |= (1 << (which % 8));
    } else {
        netsnmp_ds_booleans[storeid][which/8] &= (0xff7f >> (7 - (which % 8)));
    }

    return SNMPERR_SUCCESS;
} 

int netsnmp_ds_set_int(int storeid, int which, int value) {
    if (storeid < 0 || storeid >= NETSNMP_DS_MAX_IDS || which   < 0 || which   >= NETSNMP_DS_MAX_SUBIDS) {
        return SNMPERR_GENERR;
    }

//    DEBUGMSGTL(("netsnmp_ds_set_int", "Setting %s:%d = %d\n", stores[storeid], which, value));

    netsnmp_ds_integers[storeid][which] = value;
    return SNMPERR_SUCCESS;
}

void snmp_set_detail(const char *detail_string) {
    if (detail_string != NULL) {
//        strlcpy((char *) snmp_detail, detail_string, sizeof(snmp_detail));
        strcpy((char *) snmp_detail, detail_string);
        snmp_detail_f = 1;
    }
}
 
struct netsnmp_lookup_target {
    char* application;
    char* domain;
    char* userTarget;
    char* target;
    struct netsnmp_lookup_target* next;
};
 
static struct netsnmp_lookup_target* targets = NULL; 
/**
 * Add an (application, domain, target) triplet to the targets list if target
 * != NULL. Remove an entry if target == NULL and the userTarget pointer for
 * the entry found is also NULL. Keep at most one target per (application,
 * domain) pair.
 *
 * @return 1 if an entry for (application, domain) was already present in the
 *   targets list or 0 if such an entry was not yet present in the targets list.
 */
int netsnmp_register_default_target(const char* application, const char* domain, const char* target) {
    struct netsnmp_lookup_target *run = targets, *prev = NULL;
    int i = 0, res = 0;
    while (run && ((i = strcmp(run->application, application)) < 0 ||
		   (i == 0 && strcmp(run->domain, domain) < 0))) {
	prev = run;
	run = run->next;
    }
    if (run && i == 0 && strcmp(run->domain, domain) == 0) {
      if (run->target != NULL) {
	    free(run->target);
	    run->target = NULL;
	    res = 1;
      }
    } else {
	run = SNMP_MALLOC_STRUCT(netsnmp_lookup_target);
	run->application = strdup(application);
	run->domain = strdup(domain);
	run->userTarget = NULL;
	if (prev) {
	    run->next = prev->next;
	    prev->next = run;
	} else {
	    run->next = targets;
	    targets = run;
	}
    }
    if (target) {
	run->target = strdup(target);
    } else if (run->userTarget == NULL) {
	if (prev)
	    prev->next = run->next;
	else
	    targets = run->next;
	free(run->domain);
	free(run->application);
	free(run);
    }
    return res;
}
 
static netsnmp_tdomain udpDomain; 

int netsnmp_sockaddr_in2(struct sockaddr_in *addr, const char *inpeername, const char *default_target) {
    int ret;

    if (addr == NULL) {
        return 0;
    }

//    DEBUGMSGTL(("netsnmp_sockaddr_in", "addr %p, inpeername \"%s\", default_target \"%s\"\n", addr, inpeername ? inpeername : "[NIL]", default_target ? default_target : "[NIL]"));

    memset(addr, 0, sizeof(struct sockaddr_in));
    addr->sin_addr.s_addr = htonl(INADDR_ANY);
    addr->sin_family = AF_INET;
    addr->sin_port = htons((u_short)SNMP_PORT);

    {
	int port = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID,
				      NETSNMP_DS_LIB_DEFAULT_PORT);

	if (port != 0) {
	    addr->sin_port = htons((u_short)port);
	} else if (default_target != NULL)
	    netsnmp_sockaddr_in2(addr, default_target, NULL);
    }

    if (inpeername != NULL && *inpeername != '\0') {
	const char     *host, *port;
	char           *peername = NULL;
        char           *cp;
        /*
         * Duplicate the peername because we might want to mank around with
         * it.
         */

        peername = strdup(inpeername);
        if (peername == NULL) {
            return 0;
        }

        /*
         * Try and extract an appended port number.
         */
        cp = strchr(peername, ':');
        if (cp != NULL) {
            *cp = '\0';
            port = cp + 1;
            host = peername;
        } else {
            host = NULL;
            port = peername;
        }

        /*
         * Try to convert the user port specifier
         */
        if (port && *port == '\0')
            port = NULL;

        if (port != NULL) {
            long int l;
            char* ep;

//            DEBUGMSGTL(("netsnmp_sockaddr_in", "check user service %s\n", port));

            l = strtol(port, &ep, 10);
            if (ep != port && *ep == '\0' && 0 <= l && l <= 0x0ffff)
                addr->sin_port = htons((u_short)l);
            else {
                if (host == NULL) {
//                    DEBUGMSGTL(("netsnmp_sockaddr_in", "servname not numeric, check if it really is a destination)\n"));
                    host = port;
                    port = NULL;
                } else {
//                    DEBUGMSGTL(("netsnmp_sockaddr_in", "servname not numeric\n"));
                    free(peername);
                    return 0;
                }
            }
        }

        /*
         * Try to convert the user host specifier
         */
        if (host && *host == '\0')
            host = NULL;

        if (host != NULL) {
//            DEBUGMSGTL(("netsnmp_sockaddr_in", "check destination %s\n", host));


            if (strcmp(peername, "255.255.255.255") == 0 ) {
                /*
                 * The explicit broadcast address hack
                 */
  //              DEBUGMSGTL(("netsnmp_sockaddr_in", "Explicit UDP broadcast\n"));
                addr->sin_addr.s_addr = INADDR_NONE;
            } else {
//                ret = netsnmp_gethostbyname_v4(peername, &addr->sin_addr.s_addr);
//                ret = hostbyname(peername, &addr->sin_addr.s_addr);
								 struct hostent *remoteHost;
								 remoteHost = gethostbyname(peername);
//								 remoteHost->h_addr_list
									 addr->sin_addr.s_addr = *(u_long *) remoteHost->h_addr_list[0];

                if (ret < 0) {
//                    DEBUGMSGTL(("netsnmp_sockaddr_in", "couldn't resolve hostname\n"));
                    free(peername);
                    return 0;
                }
//                DEBUGMSGTL(("netsnmp_sockaddr_in", "hostname (resolved okay)\n"));
            }
        }
	free(peername);
    }

    /*
     * Finished
     */

    //DEBUGMSGTL(("netsnmp_sockaddr_in", "return { AF_INET, %s:%hu }\n", inet_ntoa(addr->sin_addr), ntohs(addr->sin_port)));
    return 1;
}


static const char * _sock_buf_type_get(int optname, int local) {
    if (optname == SO_SNDBUF) {
        if (local)
            return "server send buffer";
        else
            return "client send buffer";
    } else if (optname == SO_RCVBUF) {
        if (local)
            return "server receive buffer";
        else
            return "client receive buffer";
    }

    return "unknown buffer";
}
 

/*
 *
 * Get the requested buffersize, based on
 * - sockettype : client (local = 0) or server (local = 1) 
 * - buffertype : send (optname = SO_SNDBUF) or recv (SO_RCVBUF)
 *
 * In case a compile time buffer was specified, then use that one
 * if there was no runtime configuration override
 */
static int _sock_buffer_size_get(int optname, int local, const char **buftype) {
    int size;

    if (NULL != buftype)
        *buftype = _sock_buf_type_get(optname, local);

    if (optname == SO_SNDBUF) {
        if (local) {
            size = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
                    NETSNMP_DS_LIB_SERVERSENDBUF);
#ifdef NETSNMP_DEFAULT_SERVER_SEND_BUF
            if (size <= 0)
               size = NETSNMP_DEFAULT_SERVER_SEND_BUF;
#endif
        } else {
            size = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
                    NETSNMP_DS_LIB_CLIENTSENDBUF);
#ifdef NETSNMP_DEFAULT_CLIENT_SEND_BUF
            if (size <= 0)
               size = NETSNMP_DEFAULT_CLIENT_SEND_BUF;
#endif
        }
    } else if (optname == SO_RCVBUF) {
        if (local) {
            size = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
                    NETSNMP_DS_LIB_SERVERRECVBUF);
#ifdef NETSNMP_DEFAULT_SERVER_RECV_BUF
            if (size <= 0)
               size = NETSNMP_DEFAULT_SERVER_RECV_BUF;
#endif
        } else {
            size = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
                    NETSNMP_DS_LIB_CLIENTRECVBUF);
#ifdef NETSNMP_DEFAULT_CLIENT_RECV_BUF
            if (size <= 0)
               size = NETSNMP_DEFAULT_CLIENT_RECV_BUF;
#endif
        }
    } else {
        size = 0;
    }

//    DEBUGMSGTL(("socket:buffer", "Requested %s is %d\n", (buftype) ? *buftype : "unknown buffer", size));

    return(size);
}
 
/*
 * find largest possible buffer between current size and specified size.
 *
 * Try to maximize the current buffer of type "optname"
 * to the maximum allowable size by the OS (as close to
 * size as possible)
 */
static int _sock_buffer_maximize(int s, int optname, const char *buftype, int size) {
    int            curbuf = 0;
//    socklen_t      curbuflen = sizeof(int);
    int      curbuflen = sizeof(int);
    int            lo, mid, hi;

    /*
     * First we need to determine our current buffer
     */
    if ((getsockopt(s, SOL_SOCKET, optname, (char *) &curbuf, &curbuflen) == 0) 
            && (curbuflen == sizeof(int))) {

//        DEBUGMSGTL(("verbose:socket:buffer:max", "Current %s is %d\n", buftype, curbuf));

        /*
         * Let's not be stupid ... if we were asked for less than what we
         * already have, then forget about it
         */
        if (size <= curbuf) {
//            DEBUGMSGTL(("verbose:socket:buffer:max", "Requested %s <= current buffer\n", buftype));
            return curbuf;
        }

        /*
         * Do a binary search the optimal buffer within 1k of the point of
         * failure. This is rather bruteforce, but simple
         */
        hi = size;
        lo = curbuf;

        while (hi - lo > 1024) {
            mid = (lo + hi) / 2;
            if (setsockopt(s, SOL_SOCKET, optname, (char *) &mid, sizeof(int)) == 0) {
                lo = mid; /* Success: search between mid and hi */
            } else {
                hi = mid; /* Failed: search between lo and mid */
            }
        }

        /*
         * Now print if this optimization helped or not
         */
        if (getsockopt(s,SOL_SOCKET, optname, (char *) &curbuf, &curbuflen) == 0) {
//            DEBUGMSGTL(("socket:buffer:max", "Maximized %s: %d\n",buftype, curbuf));
        } 
    } else {
        /*
         * There is really not a lot we can do anymore.
         * If the OS doesn't give us the current buffer, then what's the 
         * point in trying to make it better
         */
//        DEBUGMSGTL(("socket:buffer:max", "Get %s failed ... giving up!\n", buftype));
        curbuf = -1;
    }

    return curbuf;
} 

/*
 * set socket buffer size
 *
 * @param ss     : socket
 * @param optname: SO_SNDBUF or SO_RCVBUF
 * @param local  : 1 for server, 0 for client
 * @param reqbuf : requested size, or 0 for default
 *
 * @retval    -1 : error
 * @retval    >0 : new buffer size
 */
int netsnmp_sock_buffer_set(int s, int optname, int local, int size) {
#if ! defined(SO_SNDBUF) && ! defined(SO_RCVBUF)
    DEBUGMSGTL(("socket:buffer", "Changing socket buffer is not supported\n"));
    return -1;
#else
    const char     *buftype;
    int            curbuf = 0;
    int      curbuflen = sizeof(int);

#   ifndef  SO_SNDBUF
    if (SO_SNDBUF == optname) {
        DEBUGMSGTL(("socket:buffer",
                    "Changing socket send buffer is not supported\n"));
        return -1;
    }
#   endif                          /*SO_SNDBUF */
#   ifndef  SO_RCVBUF
    if (SO_RCVBUF == optname) {
        DEBUGMSGTL(("socket:buffer",
                    "Changing socket receive buffer is not supported\n"));
        return -1;
    }
#   endif                          /*SO_RCVBUF */

    /*
     * What is the requested buffer size ?
     */
    if (0 == size)
        size = _sock_buffer_size_get(optname, local, &buftype);
    else {
        buftype = _sock_buf_type_get(optname, local);
//        DEBUGMSGT(("verbose:socket:buffer", "Requested %s is %d\n", buftype, size));
    }

    if ((getsockopt(s, SOL_SOCKET, optname, (char *) &curbuf, &curbuflen) == 0) && (curbuflen == sizeof(int))) {
        
//        DEBUGMSGT(("verbose:socket:buffer", "Original %s is %d\n", buftype, curbuf));
        if (curbuf >= size) {
//            DEBUGMSGT(("verbose:socket:buffer", "New %s size is smaller than original!\n", buftype));
        }
    }

    /*
     * If the buffersize was not specified or it was a negative value
     * then don't change the OS buffers at all
     */
    if (size <= 0) {
//       DEBUGMSGT(("socket:buffer", "%s not valid or not specified; using OS default(%d)\n", buftype,curbuf));
       return curbuf;
    }

    /*
     * Try to set the requested send buffer
     */
//    if (setsockopt(s, SOL_SOCKET, optname, (void *) &size, sizeof(int)) == 0) {
    if (setsockopt(s, SOL_SOCKET, optname, (char *) &size, sizeof(int)) == 0) {
        /*
         * Because some platforms lie about the actual buffer that has been 
         * set (Linux will always say it worked ...), we print some 
         * diagnostic output for debugging
         */
//        DEBUGIF("socket:buffer") {
//            DEBUGMSGT(("socket:buffer", "Set %s to %d\n", buftype, size));
//            if ((getsockopt(s, SOL_SOCKET, optname, (void *) &curbuf, &curbuflen) == 0) 
//                    && (curbuflen == sizeof(int))) {
//
////                DEBUGMSGT(("verbose:socket:buffer", "Now %s is %d\n", buftype, curbuf));
//            }
//        }
        /*
         * If the new buffer is smaller than the size we requested, we will
         * try to increment the new buffer with 1k increments 
         * (this will sometime allow us to reach a more optimal buffer.)
         *   For example : On Solaris, if the max OS buffer is 100k and you
         *   request 110k, you end up with the default 8k :-(
         */
        if (curbuf < size) {
            curbuf = _sock_buffer_maximize(s, optname, buftype, size);
            if(-1 != curbuf)
                size = curbuf;
        }

    } else {
        /*
         * Obviously changing the buffer failed, most like like because we 
         * requested a buffer greater than the OS limit.
         * Therefore we need to search for an optimal buffer that is close
         * enough to the point of failure.
         * This will allow us to reach a more optimal buffer.
         *   For example : On Solaris, if the max OS buffer is 100k and you 
         *   request 110k, you end up with the default 8k :-(
         *   After this quick seach we would get 1k close to 100k (the max)
         */
//        DEBUGMSGTL(("socket:buffer", "couldn't set %s to %d\n", buftype, size));

        curbuf = _sock_buffer_maximize(s, optname, buftype, size);
        if(-1 != curbuf)
            size = curbuf;
    }

    return size;
#endif
} 

void _netsnmp_udp_sockopt_set(int fd, int local) {
#ifdef  SO_BSDCOMPAT
    /*
     * Patch for Linux.  Without this, UDP packets that fail get an ICMP
     * response.  Linux turns the failed ICMP response into an error message
     * and return value, unlike all other OS's.  
     */
    if (0 == netsnmp_os_prematch("Linux","2.4"))
    {
        int             one = 1;
        DEBUGMSGTL(("socket:option", "setting socket option SO_BSDCOMPAT\n"));
        setsockopt(fd, SOL_SOCKET, SO_BSDCOMPAT, (void *) &one,
                   sizeof(one));
    }
#endif                          /*SO_BSDCOMPAT */
    /*
     * SO_REUSEADDR will allow multiple apps to open the same port at
     * the same time. Only the last one to open the socket will get
     * data. Obviously, for an agent, this is a bad thing. There should
     * only be one listener.
     */
#ifdef ALLOW_PORT_HIJACKING
#ifdef  SO_REUSEADDR
    /*
     * Allow the same port to be specified multiple times without failing.
     *    (useful for a listener)
     */
    {
        int             one = 1;
        DEBUGMSGTL(("socket:option", "setting socket option SO_REUSEADDR\n"));
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (void *) &one,
                   sizeof(one));
    }
#endif                          /*SO_REUSEADDR */
#endif

    /*
     * Try to set the send and receive buffers to a reasonably large value, so
     * that we can send and receive big PDUs (defaults to 8192 bytes (!) on
     * Solaris, for instance).  Don't worry too much about errors -- just
     * plough on regardless.  
     */
    netsnmp_sock_buffer_set(fd, SO_SNDBUF, local, 0);
    netsnmp_sock_buffer_set(fd, SO_RCVBUF, local, 0);
}

int netsnmp_socketbase_close(netsnmp_transport *t) {
    int rc = -1;
    if (t->sock >= 0) {
//#ifndef HAVE_CLOSESOCKET
//        rc = close(t->sock);
//#else
        rc = closesocket(t->sock);
//#endif
        t->sock = -1;
    }
    return rc;
} 

void netsnmp_transport_free(netsnmp_transport *t) {
    if (NULL == t)
        return;

    SNMP_FREE(t->local);
    SNMP_FREE(t->remote);
    SNMP_FREE(t->data);
    netsnmp_transport_free(t->base_transport);

    SNMP_FREE(t);
}
 
static int snmp_res_init_mutex(mutex_type *mutex) {
    int rc = 0;
#if HAVE_PTHREAD_H
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    rc = pthread_mutex_init(mutex, &attr);
    pthread_mutexattr_destroy(&attr);
#elif defined(WIN32)
    InitializeCriticalSection(mutex);
#endif

    return rc;
}
 
static mutex_type * _mt_res(int groupID, int resourceID) {
	if (groupID < 0) {
	return 0;
    }
    if (groupID >= MT_MAX_IDS) {
	return 0;
    }
    if (resourceID < 0) {
	return 0;
    }
    if (resourceID >= MT_LIB_MAXIMUM) {
	return 0;
    }
    return (&s_res[groupID][resourceID]);
}
 

int snmp_res_init(void) {
    int ii, jj, rc = 0;
    mutex_type *mutex;

    for (jj = 0; (0 == rc) && (jj < MT_MAX_IDS); jj++) {
	for (ii = 0; (0 == rc) && (ii < MT_LIB_MAXIMUM); ii++) {
	    mutex = _mt_res(jj, ii);
	    if (!mutex) {
		continue;
	    }
	    rc = snmp_res_init_mutex(mutex);
	}
    }

    return rc;
}
 

/** Compares 2 OIDs to determine if they are exactly equal.
 *  This should be faster than doing a snmp_oid_compare for different
 *  length OIDs, since the length is checked first and if != returns
 *  immediately.  Might be very slighly faster if lengths are ==.
 * @param in_name1 A pointer to the first oid.
 * @param len1     length of the first OID (in segments, not bytes)
 * @param in_name2 A pointer to the second oid.
 * @param len2     length of the second OID (in segments, not bytes)
 * @return 0 if they are equal, 1 if they are not.
 */ 
int
netsnmp_oid_equals(const oid * in_name1,
                   size_t len1, const oid * in_name2, size_t len2)
{
    register const oid *name1 = in_name1;
    register const oid *name2 = in_name2;
    register int    len = len1;

    /*
     * len = minimum of len1 and len2 
     */
    if (len1 != len2)
        return 1;
    /*
     * Handle 'null' OIDs
     */
    if (len1 == 0)
        return 0;   /* Two null OIDs are (trivially) the same */
    if (!name1 || !name2)
        return 1;   /* Otherwise something's wrong, so report a non-match */
    /*
     * find first non-matching OID 
     */
    while (len-- > 0) {
        /*
         * these must be done in seperate comparisons, since
         * subtracting them and using that result has problems with
         * subids > 2^31. 
         */
        if (*(name1++) != *(name2++))
            return 1;
    }
    return 0;
} 

int netsnmp_tdomain_register(netsnmp_tdomain *n) {
    netsnmp_tdomain **prevNext = &domain_list, *d;

    if (n != NULL) {
        for (d = domain_list; d != NULL; d = d->next) {
            if (netsnmp_oid_equals(n->name, n->name_length, d->name, d->name_length) == 0) {
                /*
                 * Already registered.  
                 */
                return 0;
            }
            prevNext = &(d->next);
        }
        n->next = NULL;
        *prevNext = n;
        return 1;
    } else {
        return 0;
    }
}
 

netsnmp_transport * netsnmp_udpipv4base_transport(struct sockaddr_in *addr, int local) {
    netsnmp_transport *t = NULL;
    int             rc = 0, rc2;
    char           *client_socket = NULL;
    netsnmp_indexed_addr_pair addr_pair;
//    socklen_t       local_addr_len;
    int        local_addr_len;

#ifdef NETSNMP_NO_LISTEN_SUPPORT
    if (local)
        return NULL;
#endif /* NETSNMP_NO_LISTEN_SUPPORT */

    if (addr == NULL || addr->sin_family != AF_INET) {
        return NULL;
    }

    memset(&addr_pair, 0, sizeof(netsnmp_indexed_addr_pair));
    memcpy(&(addr_pair.remote_addr), addr, sizeof(struct sockaddr_in));

    t = SNMP_MALLOC_TYPEDEF(netsnmp_transport);
    netsnmp_assert_or_return(t != NULL, NULL);

    //DEBUGIF("netsnmp_udpbase") {
    //    char *str = netsnmp_udp_fmtaddr(NULL, (void *)&addr_pair, sizeof(netsnmp_indexed_addr_pair));
    //    DEBUGMSGTL(("netsnmp_udpbase", "open %s %s\n", local ? "local" : "remote", str));
    //    free(str);
    //}

    t->sock = socket(PF_INET, SOCK_DGRAM, 0);
//    DEBUGMSGTL(("UDPBase", "openned socket %d as local=%d\n", t->sock, local)); 
    if (t->sock < 0) {
//        netsnmp_transport_free(t);
        return NULL;
    }

    _netsnmp_udp_sockopt_set(t->sock, local);

    if (local) {
#ifndef NETSNMP_NO_LISTEN_SUPPORT
        /*
         * This session is inteneded as a server, so we must bind on to the
         * given IP address, which may include an interface address, or could
         * be INADDR_ANY, but certainly includes a port number.
         */

        t->local = (u_char *) malloc(6);
        if (t->local == NULL) {
            netsnmp_transport_free(t);
            return NULL;
        }
        memcpy(t->local, (u_char *) & (addr->sin_addr.s_addr), 4);
        t->local[4] = (htons(addr->sin_port) & 0xff00) >> 8;
        t->local[5] = (htons(addr->sin_port) & 0x00ff) >> 0;
        t->local_length = 6;

#if defined(linux) && defined(IP_PKTINFO)
        { 
            int sockopt = 1;
            if (setsockopt(t->sock, SOL_IP, IP_PKTINFO, &sockopt, sizeof sockopt) == -1) {
                DEBUGMSGTL(("netsnmp_udpbase", "couldn't set IP_PKTINFO: %s\n",
                    strerror(errno)));
                netsnmp_transport_free(t);
                return NULL;
            }
            DEBUGMSGTL(("netsnmp_udpbase", "set IP_PKTINFO\n"));
        }
#elif defined(IP_RECVDSTADDR)
        {
            int sockopt = 1;
            if (setsockopt(t->sock, IPPROTO_IP, IP_RECVDSTADDR, (char *)&sockopt, sizeof sockopt) == -1) {
//                DEBUGMSGTL(("netsnmp_udp", "couldn't set IP_RECVDSTADDR: %s\n", strerror(errno)));
                netsnmp_transport_free(t);
                return NULL;
            }
//            DEBUGMSGTL(("netsnmp_udp", "set IP_RECVDSTADDR\n"));
        }
#endif
        rc = bind(t->sock, (struct sockaddr *) addr, sizeof(struct sockaddr));
        if (rc != 0) {
            netsnmp_socketbase_close(t);
            netsnmp_transport_free(t);
            return NULL;
        }
        t->data = NULL;
        t->data_length = 0;
#else /* NETSNMP_NO_LISTEN_SUPPORT */
        return NULL;
#endif /* NETSNMP_NO_LISTEN_SUPPORT */
    } else {
        /*
         * This is a client session.  If we've been given a
         * client address to send from, then bind to that.
         * Otherwise the send will use "something sensible".
         */
        client_socket = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID,
                                              NETSNMP_DS_LIB_CLIENT_ADDR);
        if (client_socket) {
            struct sockaddr_in client_addr;
            netsnmp_sockaddr_in2(&client_addr, client_socket, NULL);
            client_addr.sin_port = 0;
//            DEBUGMSGTL(("netsnmp_udpbase", "binding socket: %d\n", t->sock));
            rc = bind(t->sock, (struct sockaddr *)&client_addr,
                  sizeof(struct sockaddr));
            if ( rc != 0 ) {
//                DEBUGMSGTL(("netsnmp_udpbase", "failed to bind for clientaddr: %d %s\n", errno, strerror(errno)));
                netsnmp_socketbase_close(t);
                netsnmp_transport_free(t);
                return NULL;
            }
            local_addr_len = sizeof(addr_pair.local_addr);
            rc2 = getsockname(t->sock, (struct sockaddr*)&addr_pair.local_addr, &local_addr_len);
            netsnmp_assert(rc2 == 0);
        }

        //DEBUGIF("netsnmp_udpbase") {
        //    char *str = netsnmp_udp_fmtaddr(NULL, (void *)&addr_pair,
        //                                    sizeof(netsnmp_indexed_addr_pair));
        //    DEBUGMSGTL(("netsnmp_udpbase", "client open %s\n", str));
        //    free(str);
        //}

        /*
         * Save the (remote) address in the
         * transport-specific data pointer for later use by netsnmp_udp_send.
         */

        t->data = malloc(sizeof(netsnmp_indexed_addr_pair));
        t->remote = (u_char *)malloc(6);
        if (t->data == NULL || t->remote == NULL) {
            netsnmp_transport_free(t);
            return NULL;
        }
        memcpy(t->remote, (u_char *) & (addr->sin_addr.s_addr), 4);
        t->remote[4] = (htons(addr->sin_port) & 0xff00) >> 8;
        t->remote[5] = (htons(addr->sin_port) & 0x00ff) >> 0;
        t->remote_length = 6;
        memcpy(t->data, &addr_pair, sizeof(netsnmp_indexed_addr_pair));
        t->data_length = sizeof(netsnmp_indexed_addr_pair);
    }

    return t;
}

int netsnmp_udpbase_recv(netsnmp_transport *t, void *buf, int size, void **opaque, int *olength) {
    int             rc = -1;
    int       fromlen = sizeof(struct sockaddr);
    netsnmp_indexed_addr_pair *addr_pair = NULL;
    struct sockaddr *from;

    if (t != NULL && t->sock >= 0) {
        addr_pair = (netsnmp_indexed_addr_pair *) malloc(sizeof(netsnmp_indexed_addr_pair));
        if (addr_pair == NULL) {
            *opaque = NULL;
            *olength = 0;
            return -1;
        } else {
            memset(addr_pair, 0, sizeof(netsnmp_indexed_addr_pair));
            from = &addr_pair->remote_addr.sa;
        }

	while (rc < 0) {
#ifdef netsnmp_udpbase_recvfrom_sendto_defined
            socklen_t local_addr_len = sizeof(addr_pair->local_addr);
            rc = netsnmp_udp_recvfrom(t->sock, buf, size, from, &fromlen,
                                      (struct sockaddr*)&(addr_pair->local_addr),
                                      &local_addr_len, &(addr_pair->if_index));
#else
            rc = recvfrom(t->sock, (char*)buf, size, 0, from, &fromlen);
#endif /* netsnmp_udpbase_recvfrom_sendto_defined */
	    if (rc < 0 && errno != EINTR) {
		break;
	    }
	}

        if (rc >= 0) {
//            DEBUGIF("netsnmp_udp") {
//                char *str = netsnmp_udp_fmtaddr(NULL, addr_pair, sizeof(netsnmp_indexed_addr_pair));
////                DEBUGMSGTL(("netsnmp_udp","recvfrom fd %d got %d bytes (from %s)\n", t->sock, rc, str));
//                free(str);
//            }
        } else {
//            DEBUGMSGTL(("netsnmp_udp", "recvfrom fd %d err %d (\"%s\")\n", t->sock, errno, strerror(errno)));
        }
        *opaque = (void *)addr_pair;
        *olength = sizeof(netsnmp_indexed_addr_pair);
    }
    return rc;
}
 
int netsnmp_udpbase_send(netsnmp_transport *t, void *buf, int size, void **opaque, int *olength) {
    int rc = -1;
    netsnmp_indexed_addr_pair *addr_pair = NULL;
    struct sockaddr *to = NULL;

    if (opaque != NULL && *opaque != NULL &&
        ((*olength == sizeof(netsnmp_indexed_addr_pair) ||
          (*olength == sizeof(struct sockaddr_in))))) {
        addr_pair = (netsnmp_indexed_addr_pair *) (*opaque);
    } else if (t != NULL && t->data != NULL &&
                t->data_length == sizeof(netsnmp_indexed_addr_pair)) {
        addr_pair = (netsnmp_indexed_addr_pair *) (t->data);
    }

    to = &addr_pair->remote_addr.sa;

    if (to != NULL && t != NULL && t->sock >= 0) {
        //DEBUGIF("netsnmp_udp") {
        //    char *str = netsnmp_udp_fmtaddr(NULL, (void *) addr_pair, sizeof(netsnmp_indexed_addr_pair));
        //    DEBUGMSGTL(("netsnmp_udp", "send %d bytes from %p to %s on fd %d\n",
        //                size, buf, str, t->sock));
        //    free(str);
        //}
	while (rc < 0) {
#ifdef netsnmp_udpbase_recvfrom_sendto_defined
            rc = netsnmp_udp_sendto(t->sock,
                    addr_pair ? &(addr_pair->local_addr.sin.sin_addr) : NULL,
                    addr_pair ? addr_pair->if_index : 0, to, buf, size);
#else
            rc = sendto(t->sock, (char*)buf, size, 0, to, sizeof(struct sockaddr));
#endif /* netsnmp_udpbase_recvfrom_sendto_defined */
	    if (rc < 0 && errno != EINTR) {
//                DEBUGMSGTL(("netsnmp_udp", "sendto error, rc %d (errno %d)\n", rc, errno));
		break;
	    }
	}
    }
    return rc;
}

char *netsnmp_ipv4_fmtaddr(const char *prefix, netsnmp_transport *t, void *data, int len) {
    netsnmp_indexed_addr_pair *addr_pair = NULL;
    struct hostent *host;
    char tmp[64];

    if (data != NULL && len == sizeof(netsnmp_indexed_addr_pair)) {
			addr_pair = (netsnmp_indexed_addr_pair *) data;
    } else if (t != NULL && t->data != NULL) {
			addr_pair = (netsnmp_indexed_addr_pair *) t->data;
    }

    if (addr_pair == NULL) {
//        snprintf(tmp, sizeof(tmp), "%s: unknown", prefix);
        sprintf(tmp, "%s: unknown", prefix);
    } else {
        struct sockaddr_in *to = NULL;
        to = (struct sockaddr_in *) &(addr_pair->remote_addr);
        if (to == NULL) {
//            snprintf(tmp, sizeof(tmp), "%s: unknown->[%s]:%hu", prefix, inet_ntoa(addr_pair->local_addr.sin.sin_addr), ntohs(addr_pair->local_addr.sin.sin_port));
            sprintf(tmp, "%s: unknown->[%s]:%hu", prefix, inet_ntoa(addr_pair->local_addr.sin.sin_addr), ntohs(addr_pair->local_addr.sin.sin_port));
        } else if ( t && t->flags & NETSNMP_TRANSPORT_FLAG_HOSTNAME ) {
            /* XXX: hmm...  why isn't this prefixed */
            /* assuming intentional */
//            host = netsnmp_gethostbyaddr((char *)&to->sin_addr, 4, AF_INET);
            host = gethostbyaddr((char *)&to->sin_addr, 4, AF_INET);
            return (host ? strdup(host->h_name) : NULL); 
        } else {
            //snprintf(tmp, sizeof(tmp), "%s: [%s]:%hu->", prefix, inet_ntoa(to->sin_addr), ntohs(to->sin_port));
            //snprintf(tmp + strlen(tmp), sizeof(tmp)-strlen(tmp), "[%s]:%hu", inet_ntoa(addr_pair->local_addr.sin.sin_addr), ntohs(addr_pair->local_addr.sin.sin_port));
            sprintf(tmp, "%s: [%s]:%hu->", prefix, inet_ntoa(to->sin_addr), ntohs(to->sin_port));
            sprintf(tmp + strlen(tmp), "[%s]:%hu", inet_ntoa(addr_pair->local_addr.sin.sin_addr), ntohs(addr_pair->local_addr.sin.sin_port));
        }
    }
    tmp[sizeof(tmp)-1] = '\0';
    return strdup(tmp);
} 

char *netsnmp_udp_fmtaddr(netsnmp_transport *t, void *data, int len) {
    return netsnmp_ipv4_fmtaddr("UDP", t, data, len);
} 

netsnmp_transport *netsnmp_udp_transport(struct sockaddr_in *addr, int local) {
    netsnmp_transport *t = NULL;

    t = netsnmp_udpipv4base_transport(addr, local);
    if (NULL == t) {
        return NULL;
    }

    /*
     * Set Domain
     */

    t->domain = netsnmpUDPDomain;
    t->domain_length = netsnmpUDPDomain_len;

    /*
     * 16-bit length field, 8 byte UDP header, 20 byte IPv4 header  
     */

    t->msgMaxSize = 0xffff - 8 - 20;
    t->f_recv     = netsnmp_udpbase_recv;
    t->f_send     = netsnmp_udpbase_send;
    t->f_close    = netsnmp_socketbase_close;
    t->f_accept   = NULL;
    t->f_fmtaddr  = netsnmp_udp_fmtaddr;

    return t;
} 

netsnmp_transport *netsnmp_udp_create_tstring(const char *str, int local, const char *default_target) {
    struct sockaddr_in addr;

    if (netsnmp_sockaddr_in2(&addr, str, default_target)) {
        return netsnmp_udp_transport(&addr, local);
    } else {
        return NULL;
    }
} 

netsnmp_transport *netsnmp_udp_create_ostring(const u_char * o, size_t o_len, int local) {
    struct sockaddr_in addr;
    if (o_len == 6) {
        unsigned short porttmp = (o[4] << 8) + o[5];
        addr.sin_family = AF_INET;
        memcpy((u_char *) & (addr.sin_addr.s_addr), o, 4);
        addr.sin_port = htons(porttmp);
        return netsnmp_udp_transport(&addr, local);
    }
    return NULL;
}

 

void netsnmp_udp_ctor(void) {
    udpDomain.name = netsnmpUDPDomain;
    udpDomain.name_length = netsnmpUDPDomain_len;
    udpDomain.prefix = (const char**)calloc(2, sizeof(char *));
    udpDomain.prefix[0] = "udp";

    udpDomain.f_create_from_tstring     = NULL;
    udpDomain.f_create_from_tstring_new = netsnmp_udp_create_tstring;
    udpDomain.f_create_from_ostring     = netsnmp_udp_create_ostring;

    netsnmp_tdomain_register(&udpDomain);
} 


void netsnmp_tdomain_init(void) {
//    DEBUGMSGTL(("tdomain", "netsnmp_tdomain_init() called\n"));

/* include the configure generated list of constructor calls */
/*
#ifdef NETSNMP_TRANSPORT_UDP_DOMAIN
*/
netsnmp_udp_ctor();
/*
#endif

#ifdef NETSNMP_TRANSPORT_TCP_DOMAIN
netsnmp_tcp_ctor();
#endif
#ifdef NETSNMP_TRANSPORT_ALIAS_DOMAIN
netsnmp_alias_ctor();
#endif
#ifdef NETSNMP_TRANSPORT_UDPIPV6_DOMAIN
netsnmp_udpipv6_ctor();
#endif
#ifdef NETSNMP_TRANSPORT_TCPIPV6_DOMAIN
netsnmp_tcpipv6_ctor();
#endif
*/
 //   netsnmp_tdomain_dump();
}
 
static int _check_range(struct tree *tp, long ltmp, int *resptr, const char *errmsg) {
  char *cp   = NULL;
  char *temp = NULL;
  int   temp_len = 0;
  int check = !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_DONT_CHECK_RANGE);
  
	if (check && tp && tp->ranges) {
		struct range_list *rp = tp->ranges;
		while (rp) {
			if (rp->low <= ltmp && ltmp <= rp->high) break;
																	/* Allow four digits per range value */
			temp_len += ((rp->low != rp->high) ? 14 : 8 );
			rp = rp->next;
		}
		if (!rp) {
			*resptr = SNMPERR_RANGE;
			temp = (char *)malloc( temp_len+strlen(errmsg)+7);
			if ( temp ) {
				/* Append the Display Hint range information to the error message */
//				sprintf( temp, "%s :: {", errmsg );
				cp = temp+(strlen(temp));
				for ( rp = tp->ranges; rp; rp=rp->next ) {
						//if ( rp->low != rp->high ) 
						//		sprintf( cp, "(%d..%d), ", rp->low, rp->high );
						//else
						//		sprintf( cp, "(%d), ", rp->low );
						cp += strlen(cp);
				}
				*(cp-2) = '}';   /* Replace the final comma with a '}' */
				*(cp-1) = 0;
				snmp_set_detail(temp);
				free(temp);
			}
			return 0;
		}
  }
  free(temp);
  return 1;
} 

/**
 * Add an unsigned 16-bit int to an unsigned 64-bit integer.
 *
 * @param[in,out] pu64 Number to be incremented.
 * @param[in]     u16  Amount to add.
 *
 */
//void
//incrByU16(U64 * pu64, unsigned int u16)
//{
//    incrByU32(pu64, u16);
//} 

/**
 * Add an unsigned 32-bit int to an unsigned 64-bit integer.
 *
 * @param[in,out] pu64 Number to be incremented.
 * @param[in]     u32  Amount to add.
 *
 */
//void
//incrByU32(U64 * pu64, unsigned int u32)
//{
//    uint32_t tmp;
//
//    tmp = pu64->low;
//    pu64->low = (uint32_t)(tmp + u32);
//    if (pu64->low < tmp)
//        pu64->high = (uint32_t)(pu64->high + 1);
//} 

/** Convert a signed 64-bit integer from ASCII to U64. */
//int read64(U64* i64, const char *str) {
//  U64             i64p;
//  unsigned int    u;
//  int             sign = 0;
//  int             ok = 0;
//
//  zeroU64(i64);
//  if (*str == '-') {
//    sign = 1;
//    str++;
//  }
//
//  while (*str && isdigit((unsigned char)(*str))) {
//    ok = 1;
//    u = *str - '0';
//    multBy10(*i64, &i64p);
//    *i64 = i64p;
//    incrByU16(i64, u);
//    str++;
//  }
//  if (sign) {
//    i64->high = (uint32_t) ~i64->high;
//    i64->low = (uint32_t) ~i64->low;
//    incrByU16(i64, 1);
//  }
//  return ok;
//} 

/*
 * thread-safe version of strtok
 */
char *strtok_r(char *s, const char *delim, char **lasts) {
	const char *spanp;
	int c, sc;
	char *tok;

	/* s may be NULL */
	/*netsnmp_assert(delim != NULL);*/
	/*netsnmp_assert(lasts != NULL);*/

	if (s == NULL && (s = *lasts) == NULL)
		return (NULL);

	/*
	 * Skip (span) leading delimiters (s += strspn(s, delim), sort of).
	 */
cont:
	c = *s++;
	for (spanp = delim; (sc = *spanp++) != 0;) {
		if (c == sc)
			goto cont;
	}

	if (c == 0) {		/* no non-delimiter characters */
		*lasts = NULL;
		return (NULL);
	}
	tok = s - 1;

	/*
	 * Scan token (scan for delimiters: s += strcspn(s, delim), sort of).
	 * Note that delim must have one NUL; we stop if we see that, too.
	 */
	for (;;) {
		c = *s++;
		spanp = delim;
		do {
			if ((sc = *spanp++) == c) {
				if (c == 0)
					s = NULL;
				else
					s[-1] = 0;
				*lasts = s;
				return (tok);
			}
		} while (sc != 0);
	}
	/* NOTREACHED */
} 

/**
 * This function increase the size of the buffer pointed at by *buf, which is
 * initially of size *buf_len.  Contents are preserved **AT THE BOTTOM END OF
 * THE BUFFER**.  If memory can be (re-)allocated then it returns 1, else it
 * returns 0.
 * 
 * @param buf  pointer to a buffer pointer
 * @param buf_len      pointer to current size of buffer in bytes
 * 
 * @note
 * The current re-allocation algorithm is to increase the buffer size by
 * whichever is the greater of 256 bytes or the current buffer size, up to
 * a maximum increase of 8192 bytes.  
 */
int
snmp_realloc(u_char ** buf, size_t * buf_len)
{
    u_char         *new_buf = NULL;
    size_t          new_buf_len = 0;

    if (buf == NULL) {
        return 0;
    }

    if (*buf_len <= 255) {
        new_buf_len = *buf_len + 256;
    } else if (*buf_len > 255 && *buf_len <= 8191) {
        new_buf_len = *buf_len * 2;
    } else if (*buf_len > 8191) {
        new_buf_len = *buf_len + 8192;
    }

    if (*buf == NULL) {
        new_buf = (u_char *) malloc(new_buf_len);
    } else {
        new_buf = (u_char *) realloc(*buf, new_buf_len);
    }

    if (new_buf != NULL) {
        *buf = new_buf;
        *buf_len = new_buf_len;
        return 1;
    } else {
        return 0;
    }
} 

struct parse_hints {
    int length;
    int repeat;
    int format;
    int separator;
    int terminator;
    unsigned char *result;
    int result_max;
    int result_len;
}; 

#ifndef NETSNMP_DISABLE_MIB_LOADING 
static void parse_hints_reset(struct parse_hints *ph) {
    ph->length = 0;
    ph->repeat = 0;
    ph->format = 0;
    ph->separator = 0;
    ph->terminator = 0;
}
 
static void parse_hints_ctor(struct parse_hints *ph) {
    parse_hints_reset(ph);
    ph->result = NULL;
    ph->result_max = 0;
    ph->result_len = 0;
}
 
static void parse_hints_length_add_digit(struct parse_hints *ph, int digit) {
    ph->length *= 10;
    ph->length += digit - '0';
}
 
static int parse_hints_add_result_octet(struct parse_hints *ph, unsigned char octet) {
	if (!(ph->result_len < ph->result_max)) {
		ph->result_max = ph->result_len + 32;
		if (!ph->result) {
				ph->result = (unsigned char *)malloc(ph->result_max);
		} else {
				ph->result = (unsigned char *)realloc(ph->result, ph->result_max);
		}
	}
    
  if (!ph->result) {
		return 0;		/* failed */
	}

	ph->result[ph->result_len++] = octet;
	return 1;			/* success */
}
 
static int parse_hints_parse(struct parse_hints *ph, const char **v_in_out) {
    const char *v = *v_in_out;
    char *nv;
    int base;
    int repeats = 0;
    int repeat_fixup = ph->result_len;
    
    if (ph->repeat) {
	if (!parse_hints_add_result_octet(ph, 0)) {
	    return 0;
	}
    }
    do {
	base = 0;
	switch (ph->format) {
	case 'x': base += 6;	/* fall through */
	case 'd': base += 2;	/* fall through */
	case 'o': base += 8;	/* fall through */
	    {
		int i;
		unsigned long number = strtol(v, &nv, base);
		if (nv == v) return 0;
		v = nv;
		for (i = 0; i < ph->length; i++) {
		    int shift = 8 * (ph->length - 1 - i);
		    if (!parse_hints_add_result_octet(ph, (u_char)(number >> shift) )) {
			return 0; /* failed */
		    }
		}
	    }
	    break;

	case 'a':
	    {
		int i;
		    
		for (i = 0; i < ph->length && *v; i++) {
		    if (!parse_hints_add_result_octet(ph, *v++)) {
			return 0;	/* failed */
		    }
		}
	    }
	    break;
	}

	repeats++;

	if (ph->separator && *v) {
	    if (*v == ph->separator) {
		v++;
	    } else {
		return 0;		/* failed */
	    }
	}

	if (ph->terminator) {
	    if (*v == ph->terminator) {
		v++;
		break;
	    }
	}
    } while (ph->repeat && *v);
    if (ph->repeat) {
	ph->result[repeat_fixup] = repeats;
    }

    *v_in_out = v;
    return 1;
}

const char *parse_octet_hint(const char *hint, const char *value, unsigned char **new_val, int *new_val_len) {
    const char *h = hint;
    const char *v = value;
    struct parse_hints ph;
    int retval = 1;
    /* See RFC 1443 */
    enum {
	HINT_1_2,
	HINT_2_3,
	HINT_1_2_4,
	HINT_1_2_5
    } state = HINT_1_2;

    parse_hints_ctor(&ph);
    while (*h && *v && retval) {
	switch (state) {
	case HINT_1_2:
	    if ('*' == *h) {
		ph.repeat = 1;
		state = HINT_2_3;
	    } else if (isdigit((unsigned char)(*h))) {
		parse_hints_length_add_digit(&ph, *h);
		state = HINT_2_3;
	    } else {
		return v;	/* failed */
	    }
	    break;

	case HINT_2_3:
	    if (isdigit((unsigned char)(*h))) {
		parse_hints_length_add_digit(&ph, *h);
		/* state = HINT_2_3 */
	    } else if ('x' == *h || 'd' == *h || 'o' == *h || 'a' == *h) {
		ph.format = *h;
		state = HINT_1_2_4;
	    } else {
		return v;	/* failed */
	    }
	    break;

	case HINT_1_2_4:
	    if ('*' == *h) {
		retval = parse_hints_parse(&ph, &v);
		parse_hints_reset(&ph);
		
		ph.repeat = 1;
		state = HINT_2_3;
	    } else if (isdigit((unsigned char)(*h))) {
		retval = parse_hints_parse(&ph, &v);
		parse_hints_reset(&ph);
		
		parse_hints_length_add_digit(&ph, *h);
		state = HINT_2_3;
	    } else {
		ph.separator = *h;
		state = HINT_1_2_5;
	    }
	    break;

	case HINT_1_2_5:
	    if ('*' == *h) {
		retval = parse_hints_parse(&ph, &v);
		parse_hints_reset(&ph);
		
		ph.repeat = 1;
		state = HINT_2_3;
	    } else if (isdigit((unsigned char)(*h))) {
		retval = parse_hints_parse(&ph, &v);
		parse_hints_reset(&ph);
		
		parse_hints_length_add_digit(&ph, *h);
		state = HINT_2_3;
	    } else {
		ph.terminator = *h;

		retval = parse_hints_parse(&ph, &v);
		parse_hints_reset(&ph);

		state = HINT_1_2;
	    }
	    break;
	}
	h++;
    }
    while (*v && retval) {
	retval = parse_hints_parse(&ph, &v);
    }
    if (retval) {
	*new_val = ph.result;
	*new_val_len = ph.result_len;
    } else {
	if (ph.result) {
	    SNMP_FREE(ph.result);
	}
	*new_val = NULL;
	*new_val_len = 0;
    }
    return retval ? NULL : v;
}
#endif /* NETSNMP_DISABLE_MIB_LOADING */ 

int snmp_decimal_to_binary(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const char *decimal) {
    int             subid = 0;
    const char     *cp = decimal;

    if (buf == NULL || buf_len == NULL || out_len == NULL
        || decimal == NULL) {
        return 0;
    }

    while (*cp != '\0') {
        if (isspace((int) *cp) || *cp == '.') {
            cp++;
            continue;
        }
        if (!isdigit((int) *cp)) {
            return 0;
        }
        if ((subid = atoi(cp)) > 255) {
            return 0;
        }
        if ((*out_len >= *buf_len) &&
            !(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
        *(*buf + *out_len) = (u_char) subid;
        (*out_len)++;
        while (isdigit((int) *cp)) {
            cp++;
        }
    }
    return 1;
}
 

/**
 * convert an ASCII hex string (with specified delimiters) to binary
 *
 * @param buf     address of a pointer (pointer to pointer) for the output buffer.
 *                If allow_realloc is set, the buffer may be grown via snmp_realloc
 *                to accomodate the data.
 *
 * @param buf_len pointer to a size_t containing the initial size of buf.
 *
 * @param offset On input, a pointer to a size_t indicating an offset into buf.
 *                The  binary data will be stored at this offset.
 *                On output, this pointer will have updated the offset to be
 *                the first byte after the converted data.
 *
 * @param allow_realloc If true, the buffer can be reallocated. If false, and
 *                      the buffer is not large enough to contain the string,
 *                      an error will be returned.
 *
 * @param hex     pointer to hex string to be converted. May be prefixed by
 *                "0x" or "0X".
 *
 * @param delim   point to a string of allowed delimiters between bytes.
 *                If not specified, any non-hex characters will be an error.
 *
 * @retval 1  success
 * @retval 0  error
 */
int
netsnmp_hex_to_binary(u_char ** buf, size_t * buf_len, size_t * offset,
                      int allow_realloc, const char *hex, const char *delim)
{
    unsigned int    subid = 0;
    const char     *cp = hex;

    if (buf == NULL || buf_len == NULL || offset == NULL || hex == NULL) {
        return 0;
    }

    if ((*cp == '0') && ((*(cp + 1) == 'x') || (*(cp + 1) == 'X'))) {
        cp += 2;
    }

    while (*cp != '\0') {
        if (!isxdigit((int) *cp) ||
            !isxdigit((int) *(cp+1))) {
            if ((NULL != delim) && (NULL != strchr(delim, *cp))) {
                cp++;
                continue;
            }
            return 0;
        }
        if (sscanf(cp, "%2x", &subid) == 0) {
            return 0;
        }
        /*
         * if we dont' have enough space, realloc.
         * (snmp_realloc will adjust buf_len to new size)
         */
        if ((*offset >= *buf_len) &&
            !(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
        *(*buf + *offset) = (u_char) subid;
        (*offset)++;
        if (*++cp == '\0') {
            /*
             * Odd number of hex digits is an error.  
             */
            return 0;
        } else {
            cp++;
        }
    }
    return 1;
} 

/**
 * convert an ASCII hex string to binary
 *
 * @note This is a wrapper which calls netsnmp_hex_to_binary with a
 * delimiter string of " ".
 *
 * See netsnmp_hex_to_binary for parameter descriptions.
 *
 * @retval 1  success
 * @retval 0  error
 */
int
snmp_hex_to_binary(u_char ** buf, size_t * buf_len, size_t * offset, int allow_realloc, const char *hex) {
    return netsnmp_hex_to_binary(buf, buf_len, offset, allow_realloc, hex, " ");
}
 

#ifndef NETSNMP_DISABLE_MIB_LOADING
//NETSNMP_IMPORT struct tree *tree_head;
struct tree *tree_head;
static struct tree *tree_top;

NETSNMP_IMPORT struct tree *Mib;
struct tree    *Mib;            /* Backwards compatibility */
#endif /* NETSNMP_DISABLE_MIB_LOADING */ 

oid             RFC1213_MIB[] = { 1, 3, 6, 1, 2, 1 };
static char     Standard_Prefix[] = ".1.3.6.1.2.1";
 
/*
 * Set default here as some uses of read_objid require valid pointer. 
 */
static char    *Prefix = &Standard_Prefix[0];
typedef struct _PrefixList {
    const char     *str;
    int             len;
}              *PrefixListPtr, PrefixList;

/*
 * Here are the prefix strings.
 * Note that the first one finds the value of Prefix or Standard_Prefix.
 * Any of these MAY start with period; all will NOT end with period.
 * Period is added where needed.  See use of Prefix in this module.
 */
PrefixList      mib_prefixes[] = {
    {&Standard_Prefix[0]},      /* placeholder for Prefix data */
    {".iso.org.dod.internet.mgmt.mib-2"},
    {".iso.org.dod.internet.experimental"},
    {".iso.org.dod.internet.private"},
    {".iso.org.dod.internet.snmpParties"},
    {".iso.org.dod.internet.snmpSecrets"},
    {NULL, 0}                   /* end of list */
};
 
/*
 * Replace \x with x stop at eos_marker
 * return NULL if eos_marker not found
 */
static char *_apply_escapes(char *src, char eos_marker)
{
    char *dst;
    int backslash = 0;
    
    dst = src;
    while (*src) {
	if (backslash) {
	    backslash = 0;
	    *dst++ = *src;
	} else {
	    if (eos_marker == *src) break;
	    if ('\\' == *src) {
		backslash = 1;
	    } else {
		*dst++ = *src;
	    }
	}
	src++;
    }
    if (!*src) {
	/* never found eos_marker */
	return NULL;
    } else {
	*dst = 0;
	return src;
    }
} 

struct tree    *
find_tree_node(const char *name, int modid)
{
    struct tree    *tp, *headtp;
    int             count, *int_p;

    if (!name || !*name)
        return (NULL);

    headtp = tbuckets[NBUCKET(name_hash(name))];
    for (tp = headtp; tp; tp = tp->next) {
        if (tp->label && !label_compare(tp->label, name)) {

            if (modid == -1)    /* Any module */
                return (tp);

            for (int_p = tp->module_list, count = 0;
                 count < tp->number_modules; ++count, ++int_p)
                if (*int_p == modid)
                    return (tp);
        }
    }

    return (NULL);
} 

static int
#ifndef NETSNMP_DISABLE_MIB_LOADING
_add_strings_to_oid(struct tree *tp, char *cp,
                    oid * objid, size_t * objidlen, size_t maxlen)
#else
_add_strings_to_oid(void *tp, char *cp,
                    oid * objid, size_t * objidlen, size_t maxlen)
#endif /* NETSNMP_DISABLE_MIB_LOADING */
{
    oid             subid;
    int             len_index = 1000000;
#ifndef NETSNMP_DISABLE_MIB_LOADING
    struct tree    *tp2 = NULL;
    struct index_list *in_dices = NULL;
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    char           *fcp, *ecp, *cp2 = NULL;
    char            doingquote;
    int             len = -1, pos = -1;
#ifndef NETSNMP_DISABLE_MIB_LOADING
    int             check =
        !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_DONT_CHECK_RANGE);
    int             do_hint = !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_NO_DISPLAY_HINT);

    while (cp && tp && tp->child_list) {
        fcp = cp;
        tp2 = tp->child_list;
        /*
         * Isolate the next entry 
         */
        cp2 = strchr(cp, '.');
        if (cp2)
            *cp2++ = '\0';

        /*
         * Search for the appropriate child 
         */
        if (isdigit((unsigned char)(*cp))) {
            subid = strtoul(cp, &ecp, 0);
            if (*ecp)
                goto bad_id;
            while (tp2 && tp2->subid != subid)
                tp2 = tp2->next_peer;
        } else {
            while (tp2 && strcmp(tp2->label, fcp))
                tp2 = tp2->next_peer;
            if (!tp2)
                goto bad_id;
            subid = tp2->subid;
        }
        if (*objidlen >= maxlen)
            goto bad_id;
	while (tp2 && tp2->next_peer && tp2->next_peer->subid == subid)
	    tp2 = tp2->next_peer;
        objid[*objidlen] = subid;
        (*objidlen)++;

        cp = cp2;
        if (!tp2)
            break;
        tp = tp2;
    }

    if (tp && !tp->child_list) {
        if ((tp2 = tp->parent)) {
            if (tp2->indexes)
                in_dices = tp2->indexes;
            else if (tp2->augments) {
                tp2 = find_tree_node(tp2->augments, -1);
                if (tp2)
                    in_dices = tp2->indexes;
            }
        }
        tp = NULL;
    }

    while (cp && in_dices) {
        fcp = cp;

        tp = find_tree_node(in_dices->ilabel, -1);
        if (!tp)
            break;
        switch (tp->type) {
        case TYPE_INTEGER:
        case TYPE_INTEGER32:
        case TYPE_UINTEGER:
        case TYPE_UNSIGNED32:
        case TYPE_TIMETICKS:
            /*
             * Isolate the next entry 
             */
            cp2 = strchr(cp, '.');
            if (cp2)
                *cp2++ = '\0';
            if (isdigit((unsigned char)(*cp))) {
                subid = strtoul(cp, &ecp, 0);
                if (*ecp)
                    goto bad_id;
            } else {
                if (tp->enums) {
                    struct enum_list *ep = tp->enums;
                    while (ep && strcmp(ep->label, cp))
                        ep = ep->next;
                    if (!ep)
                        goto bad_id;
                    subid = ep->value;
                } else
                    goto bad_id;
            }
            if (check && tp->ranges) {
                struct range_list *rp = tp->ranges;
                int             ok = 0;
                if (tp->type == TYPE_INTEGER ||
                    tp->type == TYPE_INTEGER32) {
                  while (!ok && rp) {
                    if ((rp->low <= (int) subid)
                        && ((int) subid <= rp->high))
                        ok = 1;
                    else
                        rp = rp->next;
                  }
                } else { /* check unsigned range */
                  while (!ok && rp) {
                    if (((unsigned int)rp->low <= subid)
                        && (subid <= (unsigned int)rp->high))
                        ok = 1;
                    else
                        rp = rp->next;
                  }
                }
                if (!ok)
                    goto bad_id;
            }
            if (*objidlen >= maxlen)
                goto bad_id;
            objid[*objidlen] = subid;
            (*objidlen)++;
            break;
        case TYPE_IPADDR:
            if (*objidlen + 4 > maxlen)
                goto bad_id;
            for (subid = 0; cp && subid < 4; subid++) {
                fcp = cp;
                cp2 = strchr(cp, '.');
                if (cp2)
                    *cp2++ = 0;
                objid[*objidlen] = strtoul(cp, &ecp, 0);
                if (*ecp)
                    goto bad_id;
                if (check && objid[*objidlen] > 255)
                    goto bad_id;
                (*objidlen)++;
                cp = cp2;
            }
            break;
        case TYPE_OCTETSTR:
            if (tp->ranges && !tp->ranges->next
                && tp->ranges->low == tp->ranges->high)
                len = tp->ranges->low;
            else
                len = -1;
            pos = 0;
            if (*cp == '"' || *cp == '\'') {
                doingquote = *cp++;
                /*
                 * insert length if requested 
                 */
                if (!in_dices->isimplied && len == -1) {
                    if (doingquote == '\'') {
                        snmp_set_detail
                            ("'-quote is for fixed length strings");
                        return 0;
                    }
                    if (*objidlen >= maxlen)
                        goto bad_id;
                    len_index = *objidlen;
                    (*objidlen)++;
                } else if (doingquote == '"') {
                    snmp_set_detail
                        ("\"-quote is for variable length strings");
                    return 0;
                }

		cp2 = _apply_escapes(cp, doingquote);
		if (!cp2) goto bad_id;
		else {
		    unsigned char *new_val;
		    int new_val_len;
		    int parsed_hint = 0;
		    const char *parsed_value;

		    if (do_hint && tp->hint) {
			parsed_value = parse_octet_hint(tp->hint, cp,
			                                &new_val, &new_val_len);
			parsed_hint = parsed_value == NULL;
		    }
		    if (parsed_hint) {
			int i;
			for (i = 0; i < new_val_len; i++) {
			    if (*objidlen >= maxlen) goto bad_id;
			    objid[ *objidlen ] = new_val[i];
			    (*objidlen)++;
			    pos++;
			}
			SNMP_FREE(new_val);
		    } else {
			while(*cp) {
			    if (*objidlen >= maxlen) goto bad_id;
			    objid[ *objidlen ] = *cp++;
			    (*objidlen)++;
			    pos++;
			}
		    }
		}
		
		cp2++;
                if (!*cp2)
                    cp2 = NULL;
                else if (*cp2 != '.')
                    goto bad_id;
                else
                    cp2++;
		if (check) {
                    if (len == -1) {
                        struct range_list *rp = tp->ranges;
                        int             ok = 0;
                        while (rp && !ok)
                            if (rp->low <= pos && pos <= rp->high)
                                ok = 1;
                            else
                                rp = rp->next;
                        if (!ok)
                            goto bad_id;
                        if (!in_dices->isimplied)
                            objid[len_index] = pos;
                    } else if (pos != len)
                        goto bad_id;
		}
		else if (len == -1 && !in_dices->isimplied)
		    objid[len_index] = pos;
            } else {
                if (!in_dices->isimplied && len == -1) {
                    fcp = cp;
                    cp2 = strchr(cp, '.');
                    if (cp2)
                        *cp2++ = 0;
                    len = strtoul(cp, &ecp, 0);
                    if (*ecp)
                        goto bad_id;
                    if (*objidlen + len + 1 >= maxlen)
                        goto bad_id;
                    objid[*objidlen] = len;
                    (*objidlen)++;
                    cp = cp2;
                }
                while (len && cp) {
                    fcp = cp;
                    cp2 = strchr(cp, '.');
                    if (cp2)
                        *cp2++ = 0;
                    objid[*objidlen] = strtoul(cp, &ecp, 0);
                    if (*ecp)
                        goto bad_id;
                    if (check && objid[*objidlen] > 255)
                        goto bad_id;
                    (*objidlen)++;
                    len--;
                    cp = cp2;
                }
            }
            break;
        case TYPE_OBJID:
            in_dices = NULL;
            cp2 = cp;
            break;
	case TYPE_NETADDR:
	    fcp = cp;
	    cp2 = strchr(cp, '.');
	    if (cp2)
		*cp2++ = 0;
	    subid = strtoul(cp, &ecp, 0);
	    if (*ecp)
		goto bad_id;
	    if (*objidlen + 1 >= maxlen)
		goto bad_id;
	    objid[*objidlen] = subid;
	    (*objidlen)++;
	    cp = cp2;
	    if (subid == 1) {
		for (len = 0; cp && len < 4; len++) {
		    fcp = cp;
		    cp2 = strchr(cp, '.');
		    if (cp2)
			*cp2++ = 0;
		    subid = strtoul(cp, &ecp, 0);
		    if (*ecp)
			goto bad_id;
		    if (*objidlen + 1 >= maxlen)
			goto bad_id;
		    if (check && subid > 255)
			goto bad_id;
		    objid[*objidlen] = subid;
		    (*objidlen)++;
		    cp = cp2;
		}
	    }
	    else {
		in_dices = NULL;
	    }
	    break;
        default:
            snmp_log(LOG_ERR, "Unexpected index type: %d %s %s\n", tp->type, in_dices->ilabel, cp);
            in_dices = NULL;
            cp2 = cp;
            break;
        }
        cp = cp2;
        if (in_dices)
            in_dices = in_dices->next;
    }

#endif /* NETSNMP_DISABLE_MIB_LOADING */
    while (cp) {
        fcp = cp;
        switch (*cp) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
            cp2 = strchr(cp, '.');
            if (cp2)
                *cp2++ = 0;
            subid = strtoul(cp, &ecp, 0);
            if (*ecp)
                goto bad_id;
            if (*objidlen >= maxlen)
                goto bad_id;
            objid[*objidlen] = subid;
            (*objidlen)++;
            break;
        case '"':
        case '\'':
            doingquote = *cp++;
            /*
             * insert length if requested 
             */
            if (doingquote == '"') {
                if (*objidlen >= maxlen)
                    goto bad_id;
                objid[*objidlen] = len = strchr(cp, doingquote) - cp;
                (*objidlen)++;
            }

            if (!cp)
                goto bad_id;
            while (*cp && *cp != doingquote) {
                if (*objidlen >= maxlen)
                    goto bad_id;
                objid[*objidlen] = *cp++;
                (*objidlen)++;
            }
            cp2 = cp + 1;
            if (!*cp2)
                cp2 = NULL;
            else if (*cp2 == '.')
                cp2++;
            else
                goto bad_id;
            break;
        default:
            goto bad_id;
        }
        cp = cp2;
    }
    return 1;

  bad_id:
    {
        char            buf[256];
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (in_dices)
//            snprintf(buf, sizeof(buf), "Index out of range: %s (%s)", fcp, in_dices->ilabel);
            sprintf(buf, "Index out of range: %s (%s)", fcp, in_dices->ilabel);
        else if (tp)
//            snprintf(buf, sizeof(buf), "Sub-id not found: %s -> %s", tp->label, fcp);
            sprintf(buf, "Sub-id not found: %s -> %s", tp->label, fcp);
        else
#endif /* NETSNMP_DISABLE_MIB_LOADING */
//            snprintf(buf, sizeof(buf), "%s", fcp);
            sprintf(buf, "%s", fcp);
        buf[ sizeof(buf)-1 ] = 0;

        snmp_set_detail(buf);
    }
    return 0;
} 

#ifndef NETSNMP_DISABLE_MIB_LOADING
/**
 * @internal
 *
 * Populates the object identifier from a node in the MIB hierarchy.
 * Builds up the object ID, working backwards,
 * starting from the end of the objid buffer.
 * When the top of the MIB tree is reached, the buffer is adjusted.
 *
 * The buffer length is set to the number of subidentifiers
 * for the object identifier associated with the MIB node.
 * 
 * @return the number of subidentifiers copied.
 *
 * If 0 is returned, the objid buffer is too small,
 * and the buffer contents are indeterminate.
 * The buffer length can be used to create a larger buffer.
 */
static int node_to_oid(struct tree *tp, oid * objid, size_t * objidlen) {
    int             numids, lenids;
    oid            *op;

    if (!tp || !objid || !objidlen)
        return 0;

    lenids = (int) *objidlen;
    op = objid + lenids;        /* points after the last element */

    for (numids = 0; tp; tp = tp->parent, numids++) {
        if (numids >= lenids)
            continue;
        --op;
        *op = tp->subid;
    }

    *objidlen = (size_t) numids;
    if (numids > lenids) {
        return 0;
    }

    if (numids < lenids)
        memmove(objid, op, numids * sizeof(oid));

    return (numids);
}

/*
 * initialize: no peers included in the report. 
 */
void
clear_tree_flags(register struct tree *tp)
{
    for (; tp; tp = tp->next_peer) {
        tp->reported = 0;
        if (tp->child_list)
            clear_tree_flags(tp->child_list);
     /*RECURSE*/}
} 

/**
 * @see comments on find_best_tree_node for usage after first time.
 */
int get_wild_node(const char *name, oid * objid, size_t * objidlen) {
    struct tree    *tp = find_best_tree_node(name, tree_head, NULL);
    if (!tp)
        return 0;
    return get_node(tp->label, objid, objidlen);
}

int get_node(const char *name, oid * objid, size_t * objidlen) {
    const char     *cp;
    char            ch;
    int             res;

    cp = name;
    while ((ch = *cp))
        if (('0' <= ch && ch <= '9')
            || ('a' <= ch && ch <= 'z')
            || ('A' <= ch && ch <= 'Z')
            || ch == '-')
            cp++;
        else
            break;
    if (ch != ':')
        if (*name == '.')
            res = get_module_node(name + 1, "ANY", objid, objidlen);
        else
            res = get_module_node(name, "ANY", objid, objidlen);
    else {
        char           *module;
        /*
         *  requested name is of the form
         *      "module:subidentifier"
         */
        module = (char *) malloc((size_t) (cp - name + 1));
        if (!module)
            return SNMPERR_GENERR;
        sprintf(module, "%.*s", (int) (cp - name), name);
        cp++;                   /* cp now point to the subidentifier */
        if (*cp == ':')
            cp++;

        /*
         * 'cp' and 'name' *do* go that way round! 
         */
        res = get_module_node(cp, module, objid, objidlen);
        SNMP_FREE(module);
    }
    if (res == 0) {
        SET_SNMP_ERROR(SNMPERR_UNKNOWN_OBJID);
    }

    return res;
}

int which_module(const char *name) {
    struct module  *mp;

    for (mp = module_head; mp; mp = mp->next)
        if (!label_compare(mp->name, name))
            return (mp->modid);

//    DEBUGMSGTL(("parse-mibs", "Module %s not found\n", name));
    return (-1);
}

/**
 * Read a single character from a file. Assumes that the caller has invoked
 * flockfile(). Uses fgetc_unlocked() instead of getc() since the former is
 * implemented as an inline function in glibc. See also bug 3447196
 * (http://sourceforge.net/tracker/?func=detail&aid=3447196&group_id=12694&atid=112694).
 */
static int netsnmp_getc(FILE *stream) {
#ifdef HAVE_FGETC_UNLOCKED
    return fgetc_unlocked(stream);
#else
    return getc(stream);
#endif
}
 
static void print_error(const char *str, const char *token, int type) {
	/*
    erroneousMibs++;
    DEBUGMSGTL(("parse-mibs", "\n"));
    if (type == ENDOFFILE)
        snmp_log(LOG_ERR, "%s (EOF): At line %d in %s\n", str, mibLine,
                 File);
    else if (token && *token)
        snmp_log(LOG_ERR, "%s (%s): At line %d in %s\n", str, token,
                 mibLine, File);
    else
        snmp_log(LOG_ERR, "%s: At line %d in %s\n", str, mibLine, File);
*/
}
 

static int
parseQuoteString(FILE * fp, char *token, int maxtlen)
{
    register int    ch;
    int             count = 0;
    int             too_long = 0;
    char           *token_start = token;

    for (ch = netsnmp_getc(fp); ch != EOF; ch = netsnmp_getc(fp)) {
        if (ch == '\r')
            continue;
        if (ch == '\n') {
            mibLine++;
        } else if (ch == '"') {
            *token = '\0';
            if (too_long && netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
					   NETSNMP_DS_LIB_MIB_WARNINGS) > 1) {
                /*
                 * show short form for brevity sake 
                 */
                char            ch_save = *(token_start + 50);
                *(token_start + 50) = '\0';
                print_error("Warning: string too long", token_start, QUOTESTRING);
                *(token_start + 50) = ch_save;
            }
            return QUOTESTRING;
        }
        /*
         * maximum description length check.  If greater, keep parsing
         * but truncate the string 
         */
        if (++count < maxtlen)
            *token++ = ch;
        else
            too_long = 1;
    }

    return 0;
} 

/*
 * return zero if character is not a label character. 
 */
static int is_labelchar(int ich) {
    if ((isalnum(ich)) || (ich == '-'))
        return 1;
    if (ich == '_' && netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
					     NETSNMP_DS_LIB_MIB_PARSE_LABEL)) {
        return 1;
    }

    return 0;
} 

/*
 * Parses a token from the file.  The type of the token parsed is returned,
 * and the text is placed in the string pointed to by token.
 * Warning: this method may recurse.
 */
static int get_token(FILE * fp, char *token, int maxtlen) {
    register int    ch, ch_next;
    register char  *cp = token;
    register int    hash = 0;
    register struct tok *tp;
    int             too_long = 0;
    enum { bdigits, xdigits, other } seenSymbols;

    /*
     * skip all white space 
     */
    do {
        ch = netsnmp_getc(fp);
        if (ch == '\n')
            mibLine++;
    }
    while (isspace(ch) && ch != EOF);
    *cp++ = ch;
    *cp = '\0';
    switch (ch) {
    case EOF:
        return ENDOFFILE;
    case '"':
        return parseQuoteString(fp, token, maxtlen);
    case '\'':                 /* binary or hex constant */
        seenSymbols = bdigits;
        while ((ch = netsnmp_getc(fp)) != EOF && ch != '\'') {
            switch (seenSymbols) {
            case bdigits:
                if (ch == '0' || ch == '1')
                    break;
                seenSymbols = xdigits;
            case xdigits:
                if (isxdigit(ch))
                    break;
                seenSymbols = other;
            case other:
                break;
            }
            if (cp - token < maxtlen - 2)
                *cp++ = ch;
        }
        if (ch == '\'') {
            unsigned long   val = 0;
            char           *run = token + 1;
            ch = netsnmp_getc(fp);
            switch (ch) {
            case EOF:
                return ENDOFFILE;
            case 'b':
            case 'B':
                if (seenSymbols > bdigits) {
                    *cp++ = '\'';
                    *cp = 0;
                    return LABEL;
                }
                while (run != cp)
                    val = val * 2 + *run++ - '0';
                break;
            case 'h':
            case 'H':
                if (seenSymbols > xdigits) {
                    *cp++ = '\'';
                    *cp = 0;
                    return LABEL;
                }
                while (run != cp) {
                    ch = *run++;
                    if ('0' <= ch && ch <= '9')
                        val = val * 16 + ch - '0';
                    else if ('a' <= ch && ch <= 'f')
                        val = val * 16 + ch - 'a' + 10;
                    else if ('A' <= ch && ch <= 'F')
                        val = val * 16 + ch - 'A' + 10;
                }
                break;
            default:
                *cp++ = '\'';
                *cp = 0;
                return LABEL;
            }
            sprintf(token, "%ld", val);
            return NUMBER;
        } else
            return LABEL;
    case '(':
        return LEFTPAREN;
    case ')':
        return RIGHTPAREN;
    case '{':
        return LEFTBRACKET;
    case '}':
        return RIGHTBRACKET;
    case '[':
        return LEFTSQBRACK;
    case ']':
        return RIGHTSQBRACK;
    case ';':
        return SEMI;
    case ',':
        return COMMA;
    case '|':
        return BAR;
    case '.':
        ch_next = netsnmp_getc(fp);
        if (ch_next == '.')
            return RANGE;
        ungetc(ch_next, fp);
        return LABEL;
    case ':':
        ch_next = netsnmp_getc(fp);
        if (ch_next != ':') {
            ungetc(ch_next, fp);
            return LABEL;
        }
        ch_next = netsnmp_getc(fp);
        if (ch_next != '=') {
            ungetc(ch_next, fp);
            return LABEL;
        }
        return EQUALS;
    case '-':
        ch_next = netsnmp_getc(fp);
        if (ch_next == '-') {
            if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_MIB_COMMENT_TERM)) {
                /*
                 * Treat the rest of this line as a comment. 
                 */
                while ((ch_next != EOF) && (ch_next != '\n'))
                    ch_next = netsnmp_getc(fp);
            } else {
                /*
                 * Treat the rest of the line or until another '--' as a comment 
                 */
                /*
                 * (this is the "technically" correct way to parse comments) 
                 */
                ch = ' ';
                ch_next = netsnmp_getc(fp);
                while (ch_next != EOF && ch_next != '\n' &&
                       (ch != '-' || ch_next != '-')) {
                    ch = ch_next;
                    ch_next = netsnmp_getc(fp);
                }
            }
            if (ch_next == EOF)
                return ENDOFFILE;
            if (ch_next == '\n')
                mibLine++;
            return get_token(fp, token, maxtlen);
        }
        ungetc(ch_next, fp);
	/* fallthrough */
    default:
        /*
         * Accumulate characters until end of token is found.  Then attempt to
         * match this token as a reserved word.  If a match is found, return the
         * type.  Else it is a label.
         */
        if (!is_labelchar(ch))
            return LABEL;
        hash += tolower(ch);
      more:
        while (is_labelchar(ch_next = netsnmp_getc(fp))) {
            hash += tolower(ch_next);
            if (cp - token < maxtlen - 1)
                *cp++ = ch_next;
            else
                too_long = 1;
        }
        ungetc(ch_next, fp);
        *cp = '\0';

        if (too_long)
            print_error("Warning: token too long", token, CONTINUE);
        for (tp = buckets[BUCKET(hash)]; tp; tp = tp->next) {
            if ((tp->hash == hash) && (!label_compare(tp->name, token)))
                break;
        }
        if (tp) {
            if (tp->token != CONTINUE)
                return (tp->token);
            while (isspace((ch_next = netsnmp_getc(fp))))
                if (ch_next == '\n')
                    mibLine++;
            if (ch_next == EOF)
                return ENDOFFILE;
            if (isalnum(ch_next)) {
                *cp++ = ch_next;
                hash += tolower(ch_next);
                goto more;
            }
        }
        if (token[0] == '-' || isdigit((unsigned char)(token[0]))) {
            for (cp = token + 1; *cp; cp++)
                if (!isdigit((unsigned char)(*cp)))
                    return LABEL;
            return NUMBER;
        }
        return LABEL;
    }
}

static void scan_objlist(struct node *root, struct module *mp, struct objgroup *list, const char *error) {
    int             oLine = mibLine;

    while (list) {
        struct objgroup *gp = list;
        struct node    *np;
        list = list->next;
        np = root;
        while (np)
            if (label_compare(np->label, gp->name))
                np = np->next;
            else
                break;
        if (!np) {
	    int i;
	    struct module_import *mip;
	    /* if not local, check if it was IMPORTed */
	    for (i = 0, mip = mp->imports; i < mp->no_imports; i++, mip++)
		if (strcmp(mip->label, gp->name) == 0)
		    break;
	    if (i == mp->no_imports) {
		mibLine = gp->line;
		print_error(error, gp->name, QUOTESTRING);
	    }
        }
        free(gp->name);
        free(gp);
    }
    mibLine = oLine;
}
 
/*
 * MIB module handling routines
 */

static void dump_module_list(void) {
    struct module  *mp = module_head;

//    DEBUGMSGTL(("parse-mibs", "Module list:\n"));
    while (mp) {
//        DEBUGMSGTL(("parse-mibs", "  %s %d %s %d\n", mp->name, mp->modid, mp->file, mp->no_imports));
        mp = mp->next;
    }
}

static void init_node_hash(struct node *nodes) {
    struct node    *np, *nextp;
    int             hash;

    memset(nbuckets, 0, sizeof(nbuckets));
    for (np = nodes; np;) {
        nextp = np->next;
        hash = NBUCKET(name_hash(np->parent));
        np->next = nbuckets[hash];
        nbuckets[hash] = np;
        np = nextp;
    }
}

static int      erroneousMibs = 0; 
 
/*
 * return index into tclist of given TC descriptor
 * return -1 if not found
 */
static int get_tc_index(const char *descriptor, int modid) {
    int             i;
    struct tc      *tcp;
    struct module  *mp;
    struct module_import *mip;

    /*
     * Check that the descriptor isn't imported
     *  by searching the import list
     */

    for (mp = module_head; mp; mp = mp->next)
        if (mp->modid == modid)
            break;
    if (mp)
        for (i = 0, mip = mp->imports; i < mp->no_imports; ++i, ++mip) {
            if (!label_compare(mip->label, descriptor)) {
                /*
                 * Found it - so amend the module ID 
                 */
                modid = mip->modid;
                break;
            }
        }


    for (i = 0, tcp = tclist; i < MAXTC; i++, tcp++) {
        if (tcp->type == 0)
            break;
        if (!label_compare(descriptor, tcp->descriptor) &&
            ((modid == tcp->modid) || (modid == -1))) {
            return i;
        }
    }
    return -1;
} 

static void
free_enums(struct enum_list **spp)
{
    if (spp && *spp) {
        struct enum_list *pp, *npp;

        pp = *spp;
        *spp = NULL;

        while (pp) {
            npp = pp->next;
            if (pp->label)
                free(pp->label);
            free(pp);
            pp = npp;
        }
    }
}
 
static void
free_ranges(struct range_list **spp)
{
    if (spp && *spp) {
        struct range_list *pp, *npp;

        pp = *spp;
        *spp = NULL;

        while (pp) {
            npp = pp->next;
            free(pp);
            pp = npp;
        }
    }
}
 
static void
free_indexes(struct index_list **spp)
{
    if (spp && *spp) {
        struct index_list *pp, *npp;

        pp = *spp;
        *spp = NULL;

        while (pp) {
            npp = pp->next;
            if (pp->ilabel)
                free(pp->ilabel);
            free(pp);
            pp = npp;
        }
    }
}

static void
free_varbinds(struct varbind_list **spp)
{
    if (spp && *spp) {
        struct varbind_list *pp, *npp;

        pp = *spp;
        *spp = NULL;

        while (pp) {
            npp = pp->next;
            if (pp->vblabel)
                free(pp->vblabel);
            free(pp);
            pp = npp;
        }
    }
}
 
static void
free_partial_tree(struct tree *tp, int keep_label)
{
    if (!tp)
        return;

    /*
     * remove the data from this tree node 
     */
    free_enums(&tp->enums);
    free_ranges(&tp->ranges);
    free_indexes(&tp->indexes);
    free_varbinds(&tp->varbinds);
    if (!keep_label)
        SNMP_FREE(tp->label);
    SNMP_FREE(tp->hint);
    SNMP_FREE(tp->units);
    SNMP_FREE(tp->description);
    SNMP_FREE(tp->reference);
    SNMP_FREE(tp->augments);
    SNMP_FREE(tp->defaultValue);
}
 

/*
 * transfer data to tree from node
 *
 * move pointers for alloc'd data from np to tp.
 * this prevents them from being freed when np is released.
 * parent member is not moved.
 *
 * CAUTION: nodes may be repeats of existing tree nodes.
 * This can happen especially when resolving IMPORT clauses.
 *
 */
static void tree_from_node(struct tree *tp, struct node *np) {
    free_partial_tree(tp, FALSE);

    tp->label = np->label;
    np->label = NULL;
    tp->enums = np->enums;
    np->enums = NULL;
    tp->ranges = np->ranges;
    np->ranges = NULL;
    tp->indexes = np->indexes;
    np->indexes = NULL;
    tp->augments = np->augments;
    np->augments = NULL;
    tp->varbinds = np->varbinds;
    np->varbinds = NULL;
    tp->hint = np->hint;
    np->hint = NULL;
    tp->units = np->units;
    np->units = NULL;
    tp->description = np->description;
    np->description = NULL;
    tp->reference = np->reference;
    np->reference = NULL;
    tp->defaultValue = np->defaultValue;
    np->defaultValue = NULL;
    tp->subid = np->subid;
    tp->tc_index = np->tc_index;
    tp->type = translation_table[np->type];
    tp->access = np->access;
    tp->status = np->status;

    set_function(tp);
}

static void
unlink_tbucket(struct tree *tp)
{
    int             hash = NBUCKET(name_hash(tp->label));
    struct tree    *otp = NULL, *ntp = tbuckets[hash];

    while (ntp && ntp != tp) {
        otp = ntp;
        ntp = ntp->next;
    }
    if (!ntp)
        snmp_log(LOG_EMERG, "Can't find %s in tbuckets\n", tp->label);
    else if (otp)
        otp->next = ntp->next;
    else
        tbuckets[hash] = tp->next;
} 

/*
 * free a tree node. Note: the node must already have been unlinked
 * from the tree when calling this routine
 */
static void
free_tree(struct tree *Tree)
{
    if (!Tree)
        return;

    unlink_tbucket(Tree);
    free_partial_tree(Tree, FALSE);
    if (Tree->number_modules > 1)
        free((char *) Tree->module_list);
    free((char *) Tree);
} 

static void
free_node(struct node *np)
{
    if (!np)
        return;

    free_enums(&np->enums);
    free_ranges(&np->ranges);
    free_indexes(&np->indexes);
    free_varbinds(&np->varbinds);
    if (np->label)
        free(np->label);
    if (np->hint)
        free(np->hint);
    if (np->units)
        free(np->units);
    if (np->description)
        free(np->description);
    if (np->reference)
        free(np->reference);
    if (np->defaultValue)
        free(np->defaultValue);
    if (np->parent)
        free(np->parent);
    if (np->augments)
        free(np->augments);
    if (np->filename)
	free(np->filename);
    free((char *) np);
} 

static void merge_anon_children(struct tree *tp1, struct tree *tp2)
                /*
                 * NB: tp1 is the 'anonymous' node 
                 */
{
    struct tree    *child1, *child2, *previous;

    for (child1 = tp1->child_list; child1;) {

        for (child2 = tp2->child_list, previous = NULL;
             child2; previous = child2, child2 = child2->next_peer) {

            if (child1->subid == child2->subid) {
                /*
                 * Found 'matching' children,
                 *  so merge them
                 */
                if (!strncmp(child1->label, ANON, ANON_LEN)) {
                    merge_anon_children(child1, child2);

                    child1->child_list = NULL;
                    previous = child1;  /* Finished with 'child1' */
                    child1 = child1->next_peer;
                    free_tree(previous);
                    goto next;
                }

                else if (!strncmp(child2->label, ANON, ANON_LEN)) {
                    merge_anon_children(child2, child1);

                    if (previous)
                        previous->next_peer = child2->next_peer;
                    else
                        tp2->child_list = child2->next_peer;
                    free_tree(child2);

                    previous = child1;  /* Move 'child1' to 'tp2' */
                    child1 = child1->next_peer;
                    previous->next_peer = tp2->child_list;
                    tp2->child_list = previous;
                    for (previous = tp2->child_list;
                         previous; previous = previous->next_peer)
                        previous->parent = tp2;
                    goto next;
                } else if (!label_compare(child1->label, child2->label)) {
                    if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
					   NETSNMP_DS_LIB_MIB_WARNINGS)) {
                        snmp_log(LOG_WARNING,
                                 "Warning: %s.%ld is both %s and %s (%s)\n",
                                 tp2->label, child1->subid, child1->label,
                                 child2->label, File);
		    }
                    continue;
                } else {
                    /*
                     * Two copies of the same node.
                     * 'child2' adopts the children of 'child1'
                     */

                    if (child2->child_list) {
                        for (previous = child2->child_list; previous->next_peer; previous = previous->next_peer);       /* Find the end of the list */
                        previous->next_peer = child1->child_list;
                    } else
                        child2->child_list = child1->child_list;
                    for (previous = child1->child_list;
                         previous; previous = previous->next_peer)
                        previous->parent = child2;
                    child1->child_list = NULL;

                    previous = child1;  /* Finished with 'child1' */
                    child1 = child1->next_peer;
                    free_tree(previous);
                    goto next;
                }
            }
        }
        /*
         * If no match, move 'child1' to 'tp2' child_list
         */
        if (child1) {
            previous = child1;
            child1 = child1->next_peer;
            previous->parent = tp2;
            previous->next_peer = tp2->child_list;
            tp2->child_list = previous;
        }
      next:;
    }
}

static void unlink_tree(struct tree *tp) {
    struct tree    *otp = NULL, *ntp = tp->parent;

    if (!ntp) {                 /* this tree has no parent */
//        DEBUGMSGTL(("unlink_tree", "Tree node %s has no parent\n", tp->label));
    } else {
        ntp = ntp->child_list;

        while (ntp && ntp != tp) {
            otp = ntp;
            ntp = ntp->next_peer;
        }
        if (!ntp)
            snmp_log(LOG_EMERG, "Can't find %s in %s's children\n", tp->label, tp->parent->label);
        else if (otp)
            otp->next_peer = ntp->next_peer;
        else
            tp->parent->child_list = tp->next_peer;
    }

    if (tree_head == tp)
        tree_head = tp->next_peer;
} 

int dump_realloc_oid_to_string(const oid * objid, size_t objidlen, u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, char quotechar) {
    if (buf) {
        int             i, alen;

        for (i = 0, alen = 0; i < (int) objidlen; i++) {
            oid             tst = objid[i];
            if ((tst > 254) || (!isprint(tst))) {
                tst = (oid) '.';
            }

            if (alen == 0) {
                if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_ESCAPE_QUOTES)) {
                    while ((*out_len + 2) >= *buf_len) {
                        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                            return 0;
                        }
                    }
                    *(*buf + *out_len) = '\\';
                    (*out_len)++;
                }
                while ((*out_len + 2) >= *buf_len) {
                    if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                        return 0;
                    }
                }
                *(*buf + *out_len) = quotechar;
                (*out_len)++;
            }

            while ((*out_len + 2) >= *buf_len) {
                if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                    return 0;
                }
            }
            *(*buf + *out_len) = (char) tst;
            (*out_len)++;
            alen++;
        }

        if (alen) {
            if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_ESCAPE_QUOTES)) {
                while ((*out_len + 2) >= *buf_len) {
                    if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                        return 0;
                    }
                }
                *(*buf + *out_len) = '\\';
                (*out_len)++;
            }
            while ((*out_len + 2) >= *buf_len) {
                if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                    return 0;
                }
            }
            *(*buf + *out_len) = quotechar;
            (*out_len)++;
        }

        *(*buf + *out_len) = '\0';
    }

    return 1;
}


int snmp_strcat(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const u_char * s) {
    if (buf == NULL || buf_len == NULL || out_len == NULL) {
        return 0;
    }

    if (s == NULL) {
        /*
         * Appending a NULL string always succeeds since it is a NOP.  
         */
        return 1;
    }

    while ((*out_len + strlen((const char *) s) + 1) >= *buf_len) {
        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
    }

    strcpy((char *) (*buf + *out_len), (const char *) s);
    *out_len += strlen((char *) (*buf + *out_len));
    return 1;
}

/*
 * dump_realloc_oid_to_inetaddress:
 *   return 0 for failure,
 *   return 1 for success,
 *   return 2 for not handled
 */

int 
dump_realloc_oid_to_inetaddress(const int addr_type, const oid * objid, size_t objidlen, 
                                u_char ** buf, size_t * buf_len,
                                size_t * out_len, int allow_realloc, 
                                char quotechar)
{
    if (buf) {
        int             i, len;
        char            intbuf[64], * p;
        unsigned char  *zc;
        unsigned long   zone;

        memset(intbuf, 0, 64);

        p = intbuf;
        *p = quotechar;
        p++;
        switch (addr_type) {
            case IPV4:
            case IPV4Z:
                if ((addr_type == IPV4  && objidlen != 4) ||
                    (addr_type == IPV4Z && objidlen != 8))
                    return 2;

                len = sprintf(p, "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u."
                              "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u",
                              objid[0], objid[1], objid[2], objid[3]);
                p += len;
                if (addr_type == IPV4Z) {
                    zc = (unsigned char*)&zone;
                    zc[0] = (u_char)(objid[4]);
                    zc[1] = (u_char)(objid[5]);
                    zc[2] = (u_char)(objid[6]);
                    zc[3] = (u_char)(objid[7]);
                    zone = ntohl(zone);
                    len = sprintf(p, "%%%lu", zone);
                    p += len;
                }

                break;

            case IPV6:
            case IPV6Z:
                if ((addr_type == IPV6 && objidlen != 16) ||
                    (addr_type == IPV6Z && objidlen != 20))
                    return 2;

                len = 0;
                for (i = 0; i < 16; i ++) {
//                    len = snprintf(p, 4, "%02" NETSNMP_PRIo "x:", objid[i]);
                    len = sprintf(p, "%02" NETSNMP_PRIo "x:", objid[i]);
                    p += len;
                }
                p-- ; /* do not include the last ':' */

                if (addr_type == IPV6Z) {
                    zc = (unsigned char*)&zone;
                    zc[0] = (u_char)(objid[16]);
                    zc[1] = (u_char)(objid[17]);
                    zc[2] = (u_char)(objid[18]);
                    zc[3] = (u_char)(objid[19]);
                    zone = ntohl(zone);
                    len = sprintf(p, "%%%lu", zone);
                    p += len;
                }

                break;

            case DNS:
            default: 
                /* DNS can just be handled by dump_realloc_oid_to_string() */
                return 2;
        }

        *p = quotechar;

        return snmp_strcat(buf, buf_len, out_len, allow_realloc, (const u_char *) intbuf);
    }
    return 1;
}


/*
 * translate integer tc_index to string identifier from tclist
 * *
 * * Returns pointer to string in table (should not be modified) or NULL
 */
const char     *
get_tc_descriptor(int tc_index)
{
    if (tc_index < 0 || tc_index >= MAXTC)
        return NULL;
    return (tclist[tc_index].descriptor);
}
 
void
_oid_finish_printing(const oid * objid, size_t objidlen,
                     u_char ** buf, size_t * buf_len, size_t * out_len,
                     int allow_realloc, int *buf_overflow) {
    char            intbuf[64];
    if (*buf != NULL && *(*buf + *out_len - 1) != '.') {
        if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                           allow_realloc,
                                           (const u_char *) ".")) {
            *buf_overflow = 1;
        }
    }

    while (objidlen-- > 0) {    /* output rest of name, uninterpreted */
        sprintf(intbuf, "%" NETSNMP_PRIo "u.", *objid++);
        if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                           allow_realloc,
                                           (const u_char *) intbuf)) {
            *buf_overflow = 1;
        }
    }

    if (*buf != NULL) {
        *(*buf + *out_len - 1) = '\0';  /* remove trailing dot */
        *out_len = *out_len - 1;
    }
}

static struct tree * _get_realloc_symbol(const oid * objid, size_t objidlen,
                    struct tree *subtree,
                    u_char ** buf, size_t * buf_len, size_t * out_len,
                    int allow_realloc, int *buf_overflow,
                    struct index_list *in_dices, size_t * end_of_known)
{
    struct tree    *return_tree = NULL;
    int             extended_index =
        netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_EXTENDED_INDEX);
    int             output_format =
        netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_OID_OUTPUT_FORMAT);
    char            intbuf[64];

    if (!objid || !buf) {
        return NULL;
    }

    for (; subtree; subtree = subtree->next_peer) {
        if (*objid == subtree->subid) {
	    while (subtree->next_peer && subtree->next_peer->subid == *objid)
		subtree = subtree->next_peer;
            if (subtree->indexes) {
                in_dices = subtree->indexes;
            } else if (subtree->augments) {
                struct tree    *tp2 =
                    find_tree_node(subtree->augments, -1);
                if (tp2) {
                    in_dices = tp2->indexes;
                }
            }

            if (!strncmp(subtree->label, ANON, ANON_LEN) ||
                (NETSNMP_OID_OUTPUT_NUMERIC == output_format)) {
                sprintf(intbuf, "%lu", subtree->subid);
                if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                                   allow_realloc,
                                                   (const u_char *)
                                                   intbuf)) {
                    *buf_overflow = 1;
                }
            } else {
                if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                                   allow_realloc,
                                                   (const u_char *)
                                                   subtree->label)) {
                    *buf_overflow = 1;
                }
            }

            if (objidlen > 1) {
                if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                                   allow_realloc,
                                                   (const u_char *) ".")) {
                    *buf_overflow = 1;
                }

                return_tree = _get_realloc_symbol(objid + 1, objidlen - 1,
                                                  subtree->child_list,
                                                  buf, buf_len, out_len,
                                                  allow_realloc,
                                                  buf_overflow, in_dices,
                                                  end_of_known);
            }

            if (return_tree != NULL) {
                return return_tree;
            } else {
                return subtree;
            }
        }
    }


    if (end_of_known) {
        *end_of_known = *out_len;
    }

    /*
     * Subtree not found.  
     */

    while (in_dices && (objidlen > 0) &&
           (NETSNMP_OID_OUTPUT_NUMERIC != output_format) &&
           !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_DONT_BREAKDOWN_OIDS)) {
        size_t          numids;
        struct tree    *tp;

        tp = find_tree_node(in_dices->ilabel, -1);

        if (!tp) {
            /*
             * Can't find an index in the mib tree.  Bail.  
             */
            goto finish_it;
        }

        if (extended_index) {
            if (*buf != NULL && *(*buf + *out_len - 1) == '.') {
                (*out_len)--;
            }
            if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                               allow_realloc,
                                               (const u_char *) "[")) {
                *buf_overflow = 1;
            }
        }

        switch (tp->type) {
        case TYPE_OCTETSTR:
            if (extended_index && tp->hint) {
                netsnmp_variable_list var;
                u_char          buffer[1024];
                int             i;

                memset(&var, 0, sizeof var);
                if (in_dices->isimplied) {
                    numids = objidlen;
                    if (numids > objidlen)
                        goto finish_it;
                } else if (tp->ranges && !tp->ranges->next
                           && tp->ranges->low == tp->ranges->high) {
                    numids = tp->ranges->low;
                    if (numids > objidlen)
                        goto finish_it;
                } else {
                    numids = *objid;
                    if (numids >= objidlen)
                        goto finish_it;
                    objid++;
                    objidlen--;
                }
                if (numids > objidlen)
                    goto finish_it;
                for (i = 0; i < (int) numids; i++)
                    buffer[i] = (u_char) objid[i];
                var.type = ASN_OCTET_STR;
                var.val.string = buffer;
                var.val_len = numids;
                if (!*buf_overflow) {
                    if (!sprint_realloc_octet_string(buf, buf_len, out_len, allow_realloc, &var, NULL, tp->hint, NULL)) {
                        *buf_overflow = 1;
                    }
                }
            } else if (in_dices->isimplied) {
                numids = objidlen;
                if (numids > objidlen)
                    goto finish_it;

                if (!*buf_overflow) {
                    if (!dump_realloc_oid_to_string(objid, numids, buf, buf_len, out_len, allow_realloc, '\'')) {
                        *buf_overflow = 1;
                    }
                }
            } else if (tp->ranges && !tp->ranges->next
                       && tp->ranges->low == tp->ranges->high) {
                /*
                 * a fixed-length octet string 
                 */
                numids = tp->ranges->low;
                if (numids > objidlen)
                    goto finish_it;

                if (!*buf_overflow) {
                    if (!dump_realloc_oid_to_string
                        (objid, numids, buf, buf_len, out_len,
                         allow_realloc, '\'')) {
                        *buf_overflow = 1;
                    }
                }
            } else {
                numids = (size_t) * objid + 1;
                if (numids > objidlen)
                    goto finish_it;
                if (numids == 1) {
                    if (netsnmp_ds_get_boolean
                        (NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_ESCAPE_QUOTES)) {
                        if (!*buf_overflow
                            && !snmp_strcat(buf, buf_len, out_len,
                                            allow_realloc,
                                            (const u_char *) "\\")) {
                            *buf_overflow = 1;
                        }
                    }
                    if (!*buf_overflow
                        && !snmp_strcat(buf, buf_len, out_len,
                                        allow_realloc,
                                        (const u_char *) "\"")) {
                        *buf_overflow = 1;
                    }
                    if (netsnmp_ds_get_boolean
                        (NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_ESCAPE_QUOTES)) {
                        if (!*buf_overflow
                            && !snmp_strcat(buf, buf_len, out_len,
                                            allow_realloc,
                                            (const u_char *) "\\")) {
                            *buf_overflow = 1;
                        }
                    }
                    if (!*buf_overflow
                        && !snmp_strcat(buf, buf_len, out_len,
                                        allow_realloc,
                                        (const u_char *) "\"")) {
                        *buf_overflow = 1;
                    }
                } else {
                    if (!*buf_overflow) {
                        struct tree * next_peer;
                        int normal_handling = 1;

                        if (tp->next_peer) {
                            next_peer = tp->next_peer;
                        }

                        /* Try handling the InetAddress in the OID, in case of failure,
                         * use the normal_handling. 
                         */
                        if (tp->next_peer &&
                            tp->tc_index != -1 &&
                            next_peer->tc_index != -1 &&
                            strcmp(get_tc_descriptor(tp->tc_index), "InetAddress") == 0 &&
                            strcmp(get_tc_descriptor(next_peer->tc_index), 
                                    "InetAddressType") == 0 ) {

                            int ret;
                            int addr_type = *(objid - 1);

                            ret = dump_realloc_oid_to_inetaddress(addr_type, 
                                        objid + 1, numids - 1, buf, buf_len, out_len,
                                        allow_realloc, '"');
                            if (ret != 2) {
                                normal_handling = 0;
                                if (ret == 0) {
                                    *buf_overflow = 1;
                                }

                            }
                        } 
                        if (normal_handling && !dump_realloc_oid_to_string
                            (objid + 1, numids - 1, buf, buf_len, out_len,
                             allow_realloc, '"')) {
                            *buf_overflow = 1;
                        }
                    }
                }
            }
            objid += numids;
            objidlen -= numids;
            break;

        case TYPE_INTEGER32:
        case TYPE_UINTEGER:
        case TYPE_UNSIGNED32:
        case TYPE_GAUGE:
        case TYPE_INTEGER:
            if (tp->enums) {
                struct enum_list *ep = tp->enums;
                while (ep && ep->value != (int) (*objid)) {
                    ep = ep->next;
                }
                if (ep) {
                    if (!*buf_overflow
                        && !snmp_strcat(buf, buf_len, out_len,
                                        allow_realloc,
                                        (const u_char *) ep->label)) {
                        *buf_overflow = 1;
                    }
                } else {
                    sprintf(intbuf, "%" NETSNMP_PRIo "u", *objid);
                    if (!*buf_overflow
                        && !snmp_strcat(buf, buf_len, out_len,
                                        allow_realloc,
                                        (const u_char *) intbuf)) {
                        *buf_overflow = 1;
                    }
                }
            } else {
                sprintf(intbuf, "%" NETSNMP_PRIo "u", *objid);
                if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                                   allow_realloc,
                                                   (const u_char *)
                                                   intbuf)) {
                    *buf_overflow = 1;
                }
            }
            objid++;
            objidlen--;
            break;

        case TYPE_TIMETICKS:
            /* In an index, this is probably a timefilter */
            if (extended_index) {
                uptimeString( *objid, intbuf, sizeof( intbuf ) );
            } else {
                sprintf(intbuf, "%" NETSNMP_PRIo "u", *objid);
            }   
            if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                               allow_realloc,
                                               (const u_char *)
                                               intbuf)) {
                *buf_overflow = 1;
            }
            objid++;
            objidlen--;
            break;

        case TYPE_OBJID:
            if (in_dices->isimplied) {
                numids = objidlen;
            } else {
                numids = (size_t) * objid + 1;
            }
            if (numids > objidlen)
                goto finish_it;
            if (extended_index) {
                if (in_dices->isimplied) {
                    if (!*buf_overflow
                        && !netsnmp_sprint_realloc_objid_tree(buf, buf_len,
                                                              out_len,
                                                              allow_realloc,
                                                              buf_overflow,
                                                              objid,
                                                              numids)) {
                        *buf_overflow = 1;
                    }
                } else {
                    if (!*buf_overflow
                        && !netsnmp_sprint_realloc_objid_tree(buf, buf_len, out_len, allow_realloc, buf_overflow, objid + 1, numids - 1)) {
                        *buf_overflow = 1;
                    }
                }
            } else {
                _get_realloc_symbol(objid, numids, NULL, buf, buf_len,
                                    out_len, allow_realloc, buf_overflow,
                                    NULL, NULL);
            }
            objid += (numids);
            objidlen -= (numids);
            break;

        case TYPE_IPADDR:
            if (objidlen < 4)
                goto finish_it;
            sprintf(intbuf, "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u."
                    "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u",
                    objid[0], objid[1], objid[2], objid[3]);
            objid += 4;
            objidlen -= 4;
            if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                               allow_realloc,
                                               (const u_char *) intbuf)) {
                *buf_overflow = 1;
            }
            break;

        case TYPE_NETADDR:{
                oid             ntype = *objid++;

                objidlen--;
                sprintf(intbuf, "%" NETSNMP_PRIo "u.", ntype);
                if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                                   allow_realloc,
                                                   (const u_char *)
                                                   intbuf)) {
                    *buf_overflow = 1;
                }

                if (ntype == 1 && objidlen >= 4) {
                    sprintf(intbuf, "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u."
                            "%" NETSNMP_PRIo "u.%" NETSNMP_PRIo "u",
                            objid[0], objid[1], objid[2], objid[3]);
                    if (!*buf_overflow
                        && !snmp_strcat(buf, buf_len, out_len,
                                        allow_realloc,
                                        (const u_char *) intbuf)) {
                        *buf_overflow = 1;
                    }
                    objid += 4;
                    objidlen -= 4;
                } else {
                    goto finish_it;
                }
            }
            break;

        case TYPE_NSAPADDRESS:
        default:
            goto finish_it;
            break;
        }

        if (extended_index) {
            if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                               allow_realloc,
                                               (const u_char *) "]")) {
                *buf_overflow = 1;
            }
        } else {
            if (!*buf_overflow && !snmp_strcat(buf, buf_len, out_len,
                                               allow_realloc,
                                               (const u_char *) ".")) {
                *buf_overflow = 1;
            }
        }
        in_dices = in_dices->next;
    }

  finish_it:
    _oid_finish_printing(objid, objidlen, buf, buf_len, out_len, allow_realloc, buf_overflow);
    return NULL;
}



/**
 * 
 */
#ifdef NETSNMP_DISABLE_MIB_LOADING
void
netsnmp_sprint_realloc_objid_tree(u_char ** buf, size_t * buf_len,
                                  size_t * out_len, int allow_realloc,
                                  int *buf_overflow,
                                  const oid * objid, size_t objidlen)
{
    netsnmp_sprint_realloc_objid(buf, buf_len, out_len, allow_realloc,
                                 buf_overflow, objid, objidlen);
}
#else
struct tree    *
netsnmp_sprint_realloc_objid_tree(u_char ** buf, size_t * buf_len,
                                  size_t * out_len, int allow_realloc,
                                  int *buf_overflow,
                                  const oid * objid, size_t objidlen)
{
    u_char         *tbuf = NULL, *cp = NULL;
    size_t          tbuf_len = 512, tout_len = 0;
    struct tree    *subtree = tree_head;
    size_t          midpoint_offset = 0;
    int             tbuf_overflow = 0;
    int             output_format;

    if ((tbuf = (u_char *) calloc(tbuf_len, 1)) == NULL) {
        tbuf_overflow = 1;
    } else {
        *tbuf = '.';
        tout_len = 1;
    }

    subtree = _get_realloc_symbol(objid, objidlen, subtree, &tbuf, &tbuf_len, &tout_len, allow_realloc, &tbuf_overflow, NULL, &midpoint_offset);

    if (tbuf_overflow) {
        if (!*buf_overflow) {
            snmp_strcat(buf, buf_len, out_len, allow_realloc, tbuf);
            *buf_overflow = 1;
        }
        SNMP_FREE(tbuf);
        return subtree;
    }

    output_format = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_OID_OUTPUT_FORMAT);
    if (0 == output_format) {
        output_format = NETSNMP_OID_OUTPUT_MODULE;
    }
    switch (output_format) {
    case NETSNMP_OID_OUTPUT_FULL:
    case NETSNMP_OID_OUTPUT_NUMERIC:
        cp = tbuf;
        break;

    case NETSNMP_OID_OUTPUT_SUFFIX:
    case NETSNMP_OID_OUTPUT_MODULE:
        for (cp = tbuf; *cp; cp++);

        if (midpoint_offset != 0) {
            cp = tbuf + midpoint_offset - 2;    /*  beyond the '.'  */
        } else {
            while (cp >= tbuf) {
                if (isalpha(*cp)) {
                    break;
                }
                cp--;
            }
        }

        while (cp >= tbuf) {
            if (*cp == '.') {
                break;
            }
            cp--;
        }

        cp++;

        if ((NETSNMP_OID_OUTPUT_MODULE == output_format)
            && cp > tbuf) {
            char            modbuf[256] = { 0 }, *mod =
                module_name(subtree->modid, modbuf);

            /*
             * Don't add the module ID if it's just numeric (i.e. we couldn't look
             * it up properly.  
             */

            if (!*buf_overflow && modbuf[0] != '#') {
                if (!snmp_strcat
                    (buf, buf_len, out_len, allow_realloc,
                     (const u_char *) mod)
                    || !snmp_strcat(buf, buf_len, out_len, allow_realloc,
                                    (const u_char *) "::")) {
                    *buf_overflow = 1;
                }
            }
        }
        break;

    case NETSNMP_OID_OUTPUT_UCD:
    {
        PrefixListPtr   pp = &mib_prefixes[0];
        size_t          ilen, tlen;
        const char     *testcp;

        cp = tbuf;
        tlen = strlen((char *) tbuf);

        while (pp->str) {
            ilen = pp->len;
            testcp = pp->str;

            if ((tlen > ilen) && memcmp(tbuf, testcp, ilen) == 0) {
                cp += (ilen + 1);
                break;
            }
            pp++;
        }
        break;
    }

    case NETSNMP_OID_OUTPUT_NONE:
    default:
        cp = NULL;
    }

    if (!*buf_overflow &&
        !snmp_strcat(buf, buf_len, out_len, allow_realloc, cp)) {
        *buf_overflow = 1;
    }
    SNMP_FREE(tbuf);
    return subtree;
}
#endif /* NETSNMP_DISABLE_MIB_LOADING */



/**
 * Fallback routine for a bad type, prints "Variable has bad type" into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int
sprint_realloc_badtype(u_char ** buf, size_t * buf_len, size_t * out_len,
                       int allow_realloc,
                       const netsnmp_variable_list * var,
                       const struct enum_list *enums,
                       const char *hint, const char *units)
{
    u_char          str[] = "Variable has bad type";

    return snmp_strcat(buf, buf_len, out_len, allow_realloc, str);
}


/**
 * Universal print routine, prints a variable into a buffer according to the variable 
 * type.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_by_type(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
//    DEBUGMSGTL(("output", "sprint_by_type, type %d\n", var->type));

    switch (var->type) {
    case ASN_INTEGER:
        return sprint_realloc_integer(buf, buf_len, out_len, allow_realloc,
                                      var, enums, hint, units);
    case ASN_OCTET_STR:
        return sprint_realloc_octet_string(buf, buf_len, out_len, allow_realloc, var, enums, hint, units);
    case ASN_BIT_STR:
        return sprint_realloc_bitstring(buf, buf_len, out_len,
                                        allow_realloc, var, enums, hint,
                                        units);
    case ASN_OPAQUE:
        return sprint_realloc_opaque(buf, buf_len, out_len, allow_realloc,
                                     var, enums, hint, units);
    case ASN_OBJECT_ID:
        return sprint_realloc_object_identifier(buf, buf_len, out_len,
                                                allow_realloc, var, enums,
                                                hint, units);
    case ASN_TIMETICKS:
        return sprint_realloc_timeticks(buf, buf_len, out_len,
                                        allow_realloc, var, enums, hint,
                                        units);
    case ASN_GAUGE:
        return sprint_realloc_gauge(buf, buf_len, out_len, allow_realloc,
                                    var, enums, hint, units);
    case ASN_COUNTER:
        return sprint_realloc_counter(buf, buf_len, out_len, allow_realloc,
                                      var, enums, hint, units);
    case ASN_IPADDRESS:
        return sprint_realloc_ipaddress(buf, buf_len, out_len,
                                        allow_realloc, var, enums, hint,
                                        units);
    case ASN_NULL:
        return sprint_realloc_null(buf, buf_len, out_len, allow_realloc,
                                   var, enums, hint, units);
    case ASN_UINTEGER:
        return sprint_realloc_uinteger(buf, buf_len, out_len,
                                       allow_realloc, var, enums, hint,
                                       units);
    case ASN_COUNTER64:
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_U64:
    case ASN_OPAQUE_I64:
    case ASN_OPAQUE_COUNTER64:
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
        return sprint_realloc_counter64(buf, buf_len, out_len,
                                        allow_realloc, var, enums, hint,
                                        units);
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_FLOAT:
        return sprint_realloc_float(buf, buf_len, out_len, allow_realloc,
                                    var, enums, hint, units);
    case ASN_OPAQUE_DOUBLE:
        return sprint_realloc_double(buf, buf_len, out_len, allow_realloc,
                                     var, enums, hint, units);
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
    default:
//        DEBUGMSGTL(("sprint_by_type", "bad type: %d\n", var->type));
        return sprint_realloc_badtype(buf, buf_len, out_len, allow_realloc,
                                      var, enums, hint, units);
    }
}


int sprint_realloc_object_identifier(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    int             buf_overflow = 0;

    if ((var->type != ASN_OBJECT_ID) &&
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] =
            "Wrong Type (should be OBJECT IDENTIFIER): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len, allow_realloc, var, NULL, NULL, NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "OID: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }

    netsnmp_sprint_realloc_objid_tree(buf, buf_len, out_len, allow_realloc, &buf_overflow, (oid *) (var->val.objid), var->val_len / sizeof(oid));

    if (buf_overflow) {
        return 0;
    }

    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}


/**
 * @internal
 * Prints the character pointed to if in human-readable ASCII range,
 * otherwise prints a dot.
 *
 * @param buf Buffer to print the character to.
 * @param ch  Character to print.
 */
static void sprint_char(char *buf, const u_char ch) {
    if (isprint(ch) || isspace(ch)) {
        sprintf(buf, "%c", (int) ch);
    } else {
        sprintf(buf, ".");
    }
}


/**
 * Prints a hexadecimal string into a buffer.
 *
 * The characters pointed by *cp are encoded as hexadecimal string.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      address of the buffer to print to.
 * @param buf_len  address to an integer containing the size of buf.
 * @param out_len  incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param cp       the array of characters to encode.
 * @param line_len the array length of cp.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int
_sprint_hexstring_line(u_char ** buf, size_t * buf_len, size_t * out_len,
                       int allow_realloc, const u_char * cp, size_t line_len)
{
    const u_char   *tp;
    const u_char   *cp2 = cp;
    size_t          lenleft = line_len;

    /*
     * Make sure there's enough room for the hex output....
     */
    while ((*out_len + line_len*3+1) >= *buf_len) {
        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
    }

    /*
     * .... and display the hex values themselves....
     */
    for (; lenleft >= 8; lenleft-=8) {
        sprintf((char *) (*buf + *out_len),
                "%02X %02X %02X %02X %02X %02X %02X %02X ", cp[0], cp[1],
                cp[2], cp[3], cp[4], cp[5], cp[6], cp[7]);
        *out_len += strlen((char *) (*buf + *out_len));
        cp       += 8;
    }
    for (; lenleft > 0; lenleft--) {
        sprintf((char *) (*buf + *out_len), "%02X ", *cp++);
        *out_len += strlen((char *) (*buf + *out_len));
    }

    /*
     * .... plus (optionally) do the same for the ASCII equivalent.
     */
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_PRINT_HEX_TEXT)) {
        while ((*out_len + line_len+5) >= *buf_len) {
            if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                return 0;
            }
        }
        sprintf((char *) (*buf + *out_len), "  [");
        *out_len += strlen((char *) (*buf + *out_len));
        for (tp = cp2; tp < cp; tp++) {
            sprint_char((char *) (*buf + *out_len), *tp);
            (*out_len)++;
        }
        sprintf((char *) (*buf + *out_len), "]");
        *out_len += strlen((char *) (*buf + *out_len));
    }
    return 1;
}


int sprint_realloc_hexstring(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const u_char * cp, size_t len) {
    int line_len = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_HEX_OUTPUT_LENGTH);
    if (!line_len)
        line_len=len;

    for (; (int)len > line_len; len -= line_len) {
        if(!_sprint_hexstring_line(buf, buf_len, out_len, allow_realloc, cp, line_len))
            return 0;
        *(*buf + (*out_len)++) = '\n';
        *(*buf + *out_len) = 0;
        cp += line_len;
    }
    if(!_sprint_hexstring_line(buf, buf_len, out_len, allow_realloc, cp, len))
        return 0;
    *(*buf + *out_len) = 0;
    return 1;
}



/**
 * Prints an ascii string into a buffer.
 *
 * The characters pointed by *cp are encoded as an ascii string.
 * 
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      address of the buffer to print to.
 * @param buf_len  address to an integer containing the size of buf.
 * @param out_len  incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param cp       the array of characters to encode.
 * @param len      the array length of cp.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int
sprint_realloc_asciistring(u_char ** buf, size_t * buf_len,
                           size_t * out_len, int allow_realloc,
                           const u_char * cp, size_t len)
{
    int             i;

    for (i = 0; i < (int) len; i++) {
        if (isprint(*cp) || isspace(*cp)) {
            if (*cp == '\\' || *cp == '"') {
                if ((*out_len >= *buf_len) &&
                    !(allow_realloc && snmp_realloc(buf, buf_len))) {
                    return 0;
                }
                *(*buf + (*out_len)++) = '\\';
            }
            if ((*out_len >= *buf_len) &&
                !(allow_realloc && snmp_realloc(buf, buf_len))) {
                return 0;
            }
            *(*buf + (*out_len)++) = *cp++;
        } else {
            if ((*out_len >= *buf_len) &&
                !(allow_realloc && snmp_realloc(buf, buf_len))) {
                return 0;
            }
            *(*buf + (*out_len)++) = '.';
            cp++;
        }
    }
    if ((*out_len >= *buf_len) &&
        !(allow_realloc && snmp_realloc(buf, buf_len))) {
        return 0;
    }
    *(*buf + *out_len) = '\0';
    return 1;
}


/**
 * Prints an octet string into a buffer.
 *
 * The variable var is encoded as octet string.
 * 
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */

int sprint_realloc_octet_string(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    size_t          saved_out_len = *out_len;
    const char     *saved_hint = hint;
    int             hex = 0, x = 0;
    u_char         *cp;
    int             output_format, cnt;

    if ((var->type != ASN_OCTET_STR) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        const char      str[] = "Wrong Type (should be OCTET STRING): ";
        if (snmp_cstrcat
            (buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }


    if (hint) {
        int             repeat, width = 1;
        long            value;
        char            code = 'd', separ = 0, term = 0, ch, intbuf[32];
#define HEX2DIGIT_NEED_INIT 3
        char            hex2digit = HEX2DIGIT_NEED_INIT;
        u_char         *ecp;

        if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
            if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, "STRING: ")) {
                return 0;
            }
        }
        cp = var->val.string;
        ecp = cp + var->val_len;

        while (cp < ecp) {
            repeat = 1;
            if (*hint) {
                if (*hint == '*') {
                    repeat = *cp++;
                    hint++;
                }
                width = 0;
                while ('0' <= *hint && *hint <= '9')
                    width = (width * 10) + (*hint++ - '0');
                code = *hint++;
                if ((ch = *hint) && ch != '*' && (ch < '0' || ch > '9')
                    && (width != 0
                        || (ch != 'x' && ch != 'd' && ch != 'o')))
                    separ = *hint++;
                else
                    separ = 0;
                if ((ch = *hint) && ch != '*' && (ch < '0' || ch > '9')
                    && (width != 0
                        || (ch != 'x' && ch != 'd' && ch != 'o')))
                    term = *hint++;
                else
                    term = 0;
                if (width == 0)  /* Handle malformed hint strings */
                    width = 1;
            }

            while (repeat && cp < ecp) {
                value = 0;
                if (code != 'a' && code != 't') {
                    for (x = 0; x < width; x++) {
                        value = value * 256 + *cp++;
                    }
                }
                switch (code) {
                case 'x':
                    if (HEX2DIGIT_NEED_INIT == hex2digit)
                        hex2digit = netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID,
                                                           NETSNMP_DS_LIB_2DIGIT_HEX_OUTPUT);
                    /*
                     * if value is < 16, it will be a single hex digit. If the
                     * width is 1 (we are outputting a byte at a time), pat it
                     * to 2 digits if NETSNMP_DS_LIB_2DIGIT_HEX_OUTPUT is set
                     * or all of the following are true:
                     *  - we do not have a separation character
                     *  - there is no hint left (or there never was a hint)
                     *
                     * e.g. for the data 0xAA01BB, would anyone really ever
                     * want the string "AA1BB"??
                     */
                    if (((value < 16) && (1 == width)) &&
                        (hex2digit || ((0 == separ) && (0 == *hint)))) {
                        sprintf(intbuf, "0%lx", value);
                    } else {
                        sprintf(intbuf, "%lx", value);
                    }
                    if (!snmp_cstrcat
                        (buf, buf_len, out_len, allow_realloc, intbuf)) {
                        return 0;
                    }
                    break;
                case 'd':
                    sprintf(intbuf, "%ld", value);
                    if (!snmp_cstrcat
                        (buf, buf_len, out_len, allow_realloc, intbuf)) {
                        return 0;
                    }
                    break;
                case 'o':
                    sprintf(intbuf, "%lo", value);
                    if (!snmp_cstrcat
                        (buf, buf_len, out_len, allow_realloc, intbuf)) {
                        return 0;
                    }
                    break;
                case 't': /* new in rfc 3411 */
                case 'a':
                    cnt = SNMP_MIN(width, ecp - cp);
                    if (!sprint_realloc_asciistring(buf, buf_len, out_len,
                                                    allow_realloc, cp, cnt))
                        return 0;
                    cp += cnt;
                    break;
                default:
                    *out_len = saved_out_len;
                    if (snmp_cstrcat(buf, buf_len, out_len, allow_realloc,
                                     "(Bad hint ignored: ")
                        && snmp_cstrcat(buf, buf_len, out_len,
                                       allow_realloc, saved_hint)
                        && snmp_cstrcat(buf, buf_len, out_len,
                                       allow_realloc, ") ")) {
                        return sprint_realloc_octet_string(buf, buf_len,
                                                           out_len,
                                                           allow_realloc,
                                                           var, enums,
                                                           NULL, NULL);
                    } else {
                        return 0;
                    }
                }

                if (cp < ecp && separ) {
                    while ((*out_len + 1) >= *buf_len) {
                        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                            return 0;
                        }
                    }
                    *(*buf + *out_len) = separ;
                    (*out_len)++;
                    *(*buf + *out_len) = '\0';
                }
                repeat--;
            }

            if (term && cp < ecp) {
                while ((*out_len + 1) >= *buf_len) {
                    if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
                        return 0;
                    }
                }
                *(*buf + *out_len) = term;
                (*out_len)++;
                *(*buf + *out_len) = '\0';
            }
        }

        if (units) {
            return (snmp_cstrcat
                    (buf, buf_len, out_len, allow_realloc, " ")
                    && snmp_cstrcat(buf, buf_len, out_len, allow_realloc, units));
        }
        if ((*out_len >= *buf_len) &&
            !(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
        *(*buf + *out_len) = '\0';

        return 1;
    }

    output_format = netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_STRING_OUTPUT_FORMAT);
    if (0 == output_format) {
        output_format = NETSNMP_STRING_OUTPUT_GUESS;
    }
    switch (output_format) {
    case NETSNMP_STRING_OUTPUT_GUESS:
        hex = 0;
        for (cp = var->val.string, x = 0; x < (int) var->val_len; x++, cp++) {
            if (!isprint(*cp) && !isspace(*cp)) {
                hex = 1;
            }
        }
        break;

    case NETSNMP_STRING_OUTPUT_ASCII:
        hex = 0;
        break;

    case NETSNMP_STRING_OUTPUT_HEX:
        hex = 1;
        break;
    }

    if (var->val_len == 0) {
        return snmp_cstrcat(buf, buf_len, out_len, allow_realloc, "\"\"");
    }

    if (hex) {
        if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
            if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, "\"")) {
                return 0;
            }
        } else {
            if (!snmp_cstrcat
                (buf, buf_len, out_len, allow_realloc, "Hex-STRING: ")) {
                return 0;
            }
        }

        if (!sprint_realloc_hexstring(buf, buf_len, out_len, allow_realloc,
                                      var->val.string, var->val_len)) {
            return 0;
        }

        if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
            if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, "\"")) {
                return 0;
            }
        }
    } else {
        if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
            if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc,
                             "STRING: ")) {
                return 0;
            }
        }
        if (!snmp_cstrcat
            (buf, buf_len, out_len, allow_realloc, "\"")) {
            return 0;
        }
        if (!sprint_realloc_asciistring
            (buf, buf_len, out_len, allow_realloc, var->val.string,
             var->val_len)) {
            return 0;
        }
        if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, "\"")) {
            return 0;
        }
    }

    if (units) {
        return (snmp_cstrcat(buf, buf_len, out_len, allow_realloc, " ")
                && snmp_cstrcat(buf, buf_len, out_len, allow_realloc, units));
    }
    return 1;
}


/**
 * Prints an integer according to the hint into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param val      The variable to encode.
 * @param decimaltype The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may _NOT_ be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_hinted_integer(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, long val, const char decimaltype, const char *hint, const char *units) {
    char            fmt[10] = "%l@", tmp[256];
    int             shift, len;

    if (hint[1] == '-') {
        shift = atoi(hint + 2);
    } else {
        shift = 0;
    }

    if (hint[0] == 'd') {
        /*
         * We might *actually* want a 'u' here.  
         */
        fmt[2] = decimaltype;
    } else {
        /*
         * DISPLAY-HINT character is 'b', 'o', or 'x'.  
         */
        fmt[2] = hint[0];
    }

    sprintf(tmp, fmt, val);
    if (shift != 0) {
        len = strlen(tmp);
        if (shift <= len) {
            tmp[len + 1] = 0;
            while (shift--) {
                tmp[len] = tmp[len - 1];
                len--;
            }
            tmp[len] = '.';
        } else {
            tmp[shift + 1] = 0;
            while (shift) {
                if (len-- > 0) {
                    tmp[shift] = tmp[len];
                } else {
                    tmp[shift] = '0';
                }
                shift--;
            }
            tmp[0] = '.';
        }
    }
    return snmp_strcat(buf, buf_len, out_len, allow_realloc, (u_char *)tmp);
}




/**
 * Prints an integer into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_integer(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char           *enum_string = NULL;

    if ((var->type != ASN_INTEGER) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be INTEGER): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }
    for (; enums; enums = enums->next) {
        if (enums->value == *var->val.integer) {
            enum_string = enums->label;
            break;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc,
                         (const u_char *) "INTEGER: ")) {
            return 0;
        }
    }

    if (enum_string == NULL ||
        netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_PRINT_NUMERIC_ENUM)) {
        if (hint) {
            if (!(sprint_realloc_hinted_integer(buf, buf_len, out_len,
                                                allow_realloc,
                                                *var->val.integer, 'd',
                                                hint, units))) {
                return 0;
            }
        } else {
            char            str[32];
            sprintf(str, "%ld", *var->val.integer);
            if (!snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) str)) {
                return 0;
            }
        }
    } else if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc,
             (const u_char *) enum_string)) {
            return 0;
        }
    } else {
        char            str[32];
        sprintf(str, "(%ld)", *var->val.integer);
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc,
             (const u_char *) enum_string)) {
            return 0;
        }
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc, (const u_char *) str)) {
            return 0;
        }
    }

    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}

/**
 * Prints a network address into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_networkaddress(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    size_t          i;

    if ((var->type != ASN_IPADDRESS) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be NetworkAddress): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "Network Address: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }

    while ((*out_len + (var->val_len * 3) + 2) >= *buf_len) {
        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
    }

    for (i = 0; i < var->val_len; i++) {
        sprintf((char *) (*buf + *out_len), "%02X", var->val.string[i]);
        *out_len += 2;
        if (i < var->val_len - 1) {
            *(*buf + *out_len) = ':';
            (*out_len)++;
        }
    }
    return 1;
}

/**
 * Prints an ip-address into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_ipaddress(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    u_char         *ip = var->val.string;

    if ((var->type != ASN_IPADDRESS) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be IpAddress): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "IpAddress: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }
    while ((*out_len + 17) >= *buf_len) {
        if (!(allow_realloc && snmp_realloc(buf, buf_len))) {
            return 0;
        }
    }
    if (ip)
        sprintf((char *) (*buf + *out_len), "%d.%d.%d.%d",
                                            ip[0], ip[1], ip[2], ip[3]);
    *out_len += strlen((char *) (*buf + *out_len));
    return 1;
}


/**
 * Prints a counter into a buffer.
 *
 * The variable var is encoded as a counter value.
 * 
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_counter64(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char            a64buf[I64CHARSZ + 1];

    if ((var->type != ASN_COUNTER64
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
        && var->type != ASN_OPAQUE_COUNTER64
        && var->type != ASN_OPAQUE_I64 && var->type != ASN_OPAQUE_U64
#endif
        ) && (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        if (snmp_cstrcat(buf, buf_len, out_len, allow_realloc, 
                        "Wrong Type (should be Counter64): ")) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
        if (var->type != ASN_COUNTER64) {
            if (!snmp_cstrcat
                (buf, buf_len, out_len, allow_realloc, "Opaque: ")) {
                return 0;
            }
        }
#endif
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
        switch (var->type) {
        case ASN_OPAQUE_U64:
            if (!snmp_cstrcat
                (buf, buf_len, out_len, allow_realloc, "UInt64: ")) {
                return 0;
            }
            break;
        case ASN_OPAQUE_I64:
            if (!snmp_cstrcat
                (buf, buf_len, out_len, allow_realloc, "Int64: ")) {
                return 0;
            }
            break;
        case ASN_COUNTER64:
        case ASN_OPAQUE_COUNTER64:
#endif
            if (!snmp_cstrcat
                (buf, buf_len, out_len, allow_realloc, "Counter64: ")) {
                return 0;
            }
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
        }
#endif
    }
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    if (var->type == ASN_OPAQUE_I64) {
        printI64(a64buf, var->val.counter64);
        if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, a64buf)) {
            return 0;
        }
    } else {
#endif
        printU64(a64buf, var->val.counter64);
        if (!snmp_cstrcat(buf, buf_len, out_len, allow_realloc, a64buf)) {
            return 0;
        }
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    }
#endif

    if (units) {
        return (snmp_cstrcat(buf, buf_len, out_len, allow_realloc, " ")
                && snmp_cstrcat(buf, buf_len, out_len, allow_realloc, units));
    }
    return 1;
}


/**
 * Prints a counter value into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_counter(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char            tmp[32];

    if ((var->type != ASN_COUNTER) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be Counter32): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "Counter32: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }
    sprintf(tmp, "%u", (unsigned int)(*var->val.integer & 0xffffffff));
    if (!snmp_strcat
        (buf, buf_len, out_len, allow_realloc, (const u_char *) tmp)) {
        return 0;
    }
    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}


/**
 * Prints a gauge value into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_gauge(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char            tmp[32];

    if ((var->type != ASN_GAUGE) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] =
            "Wrong Type (should be Gauge32 or Unsigned32): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "Gauge32: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }
    if (hint) {
        if (!sprint_realloc_hinted_integer(buf, buf_len, out_len,
                                           allow_realloc,
                                           *var->val.integer, 'u', hint,
                                           units)) {
            return 0;
        }
    } else {
        sprintf(tmp, "%u", (unsigned int)(*var->val.integer & 0xffffffff));
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc, (const u_char *) tmp)) {
            return 0;
        }
    }
    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}

/**
 * @internal
 * Converts timeticks to hours, minutes, seconds string.
 *
 * @param timeticks    The timeticks to convert.
 * @param buf          Buffer to write to, has to be at 
 *                     least 40 Bytes large.
 *       
 * @return The buffer.
 */
static char * uptimeString(u_long timeticks, char *buf, size_t buflen) {
    int             centisecs, seconds, minutes, hours, days;

    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_NUMERIC_TIMETICKS)) {
//        snprintf(buf, buflen, "%lu", timeticks);
        sprintf(buf, "%lu", timeticks);
        return buf;
    }


    centisecs = timeticks % 100;
    timeticks /= 100;
    days = timeticks / (60 * 60 * 24);
    timeticks %= (60 * 60 * 24);

    hours = timeticks / (60 * 60);
    timeticks %= (60 * 60);

    minutes = timeticks / 60;
    seconds = timeticks % 60;

    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT))
//        snprintf(buf, buflen, "%d:%d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
        sprintf(buf, "%d:%d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
    else {
        if (days == 0) {
//            snprintf(buf, buflen, "%d:%02d:%02d.%02d", hours, minutes, seconds, centisecs);
            sprintf(buf, "%d:%02d:%02d.%02d", hours, minutes, seconds, centisecs);
        } else if (days == 1) {
//            snprintf(buf, buflen, "%d day, %d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
            sprintf(buf, "%d day, %d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
        } else {
//            snprintf(buf, buflen, "%d days, %d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
            sprintf(buf, "%d days, %d:%02d:%02d.%02d", days, hours, minutes, seconds, centisecs);
        }
    }
    return buf;
}


/**
 * Prints a timetick variable into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_timeticks(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char            timebuf[40];

    if ((var->type != ASN_TIMETICKS) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be Timeticks): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_NUMERIC_TIMETICKS)) {
        char            str[32];
        sprintf(str, "%lu", *(u_long *) var->val.integer);
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc, (const u_char *) str)) {
            return 0;
        }
        return 1;
    }
    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        char            str[32];
        sprintf(str, "Timeticks: (%lu) ", *(u_long *) var->val.integer);
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc, (const u_char *) str)) {
            return 0;
        }
    }
    uptimeString(*(u_long *) (var->val.integer), timebuf, sizeof(timebuf));
    if (!snmp_strcat
        (buf, buf_len, out_len, allow_realloc, (const u_char *) timebuf)) {
        return 0;
    }
    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}


/**
 * Prints an object identifier into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_opaque(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    if ((var->type != ASN_OPAQUE
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
        && var->type != ASN_OPAQUE_COUNTER64
        && var->type != ASN_OPAQUE_U64
        && var->type != ASN_OPAQUE_I64
        && var->type != ASN_OPAQUE_FLOAT && var->type != ASN_OPAQUE_DOUBLE
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
        ) && (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        if (snmp_cstrcat(buf, buf_len, out_len, allow_realloc, 
                         "Wrong Type (should be Opaque): ")) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    switch (var->type) {
    case ASN_OPAQUE_COUNTER64:
    case ASN_OPAQUE_U64:
    case ASN_OPAQUE_I64:
        return sprint_realloc_counter64(buf, buf_len, out_len,
                                        allow_realloc, var, enums, hint,
                                        units);
        break;

    case ASN_OPAQUE_FLOAT:
        return sprint_realloc_float(buf, buf_len, out_len, allow_realloc,
                                    var, enums, hint, units);
        break;

    case ASN_OPAQUE_DOUBLE:
        return sprint_realloc_double(buf, buf_len, out_len, allow_realloc,
                                     var, enums, hint, units);
        break;

    case ASN_OPAQUE:
#endif
        if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
            u_char          str[] = "OPAQUE: ";
            if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
                return 0;
            }
        }
        if (!sprint_realloc_hexstring(buf, buf_len, out_len, allow_realloc,
                                      var->val.string, var->val_len)) {
            return 0;
        }
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    }
#endif
    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}

/**
 * Prints a null value into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_null(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    if ((var->type != ASN_NULL) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be NULL): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    } else {
        u_char          str[] = "NULL";
        return snmp_strcat(buf, buf_len, out_len, allow_realloc, str);
    }
}



/**
 * Prints a bit string into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_bitstring(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    int             len, bit;
    u_char         *cp;
    char           *enum_string;

    if ((var->type != ASN_BIT_STR && var->type != ASN_OCTET_STR) &&
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be BITS): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "\"";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    } else {
        u_char          str[] = "BITS: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }
    if (!sprint_realloc_hexstring(buf, buf_len, out_len, allow_realloc,
                                  var->val.bitstring, var->val_len)) {
        return 0;
    }

    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "\"";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    } else {
        cp = var->val.bitstring;
        for (len = 0; len < (int) var->val_len; len++) {
            for (bit = 0; bit < 8; bit++) {
                if (*cp & (0x80 >> bit)) {
                    enum_string = NULL;
                    for (; enums; enums = enums->next) {
                        if (enums->value == (len * 8) + bit) {
                            enum_string = enums->label;
                            break;
                        }
                    }
                    if (enum_string == NULL ||
                        netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID,
                                       NETSNMP_DS_LIB_PRINT_NUMERIC_ENUM)) {
                        char            str[32];
                        sprintf(str, "%d ", (len * 8) + bit);
                        if (!snmp_strcat
                            (buf, buf_len, out_len, allow_realloc,
                             (const u_char *) str)) {
                            return 0;
                        }
                    } else {
                        char            str[32];
                        sprintf(str, "(%d) ", (len * 8) + bit);
                        if (!snmp_strcat
                            (buf, buf_len, out_len, allow_realloc,
                             (const u_char *) enum_string)) {
                            return 0;
                        }
                        if (!snmp_strcat
                            (buf, buf_len, out_len, allow_realloc,
                             (const u_char *) str)) {
                            return 0;
                        }
                    }
                }
            }
            cp++;
        }
    }
    return 1;
}


int sprint_realloc_nsapaddress(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    if ((var->type != ASN_NSAP) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be NsapAddress): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    if (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        u_char          str[] = "NsapAddress: ";
        if (!snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return 0;
        }
    }

    return sprint_realloc_hexstring(buf, buf_len, out_len, allow_realloc,
                                    var->val.string, var->val_len);
}


/**
 * Prints an unsigned integer into a buffer.
 *
 * If allow_realloc is true the buffer will be (re)allocated to fit in the 
 * needed size. (Note: *buf may change due to this.)
 * 
 * @param buf      Address of the buffer to print to.
 * @param buf_len  Address to an integer containing the size of buf.
 * @param out_len  Incremented by the number of characters printed.
 * @param allow_realloc if not zero reallocate the buffer to fit the 
 *                      needed size.
 * @param var      The variable to encode.
 * @param enums    The enumeration ff this variable is enumerated. may be NULL.
 * @param hint     Contents of the DISPLAY-HINT clause of the MIB.
 *                 See RFC 1903 Section 3.1 for details. may be NULL.
 * @param units    Contents of the UNITS clause of the MIB. may be NULL.
 * 
 * @return 1 on success, or 0 on failure (out of memory, or buffer to
 *         small when not allowed to realloc.)
 */
int sprint_realloc_uinteger(u_char ** buf, size_t * buf_len, size_t * out_len, int allow_realloc, const netsnmp_variable_list * var, const struct enum_list *enums, const char *hint, const char *units) {
    char           *enum_string = NULL;

    if ((var->type != ASN_UINTEGER) && 
        (!netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICKE_PRINT))) {
        u_char          str[] = "Wrong Type (should be UInteger32): ";
        if (snmp_strcat(buf, buf_len, out_len, allow_realloc, str)) {
            return sprint_realloc_by_type(buf, buf_len, out_len,
                                          allow_realloc, var, NULL, NULL,
                                          NULL);
        } else {
            return 0;
        }
    }

    for (; enums; enums = enums->next) {
        if (enums->value == *var->val.integer) {
            enum_string = enums->label;
            break;
        }
    }

    if (enum_string == NULL ||
        netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_PRINT_NUMERIC_ENUM)) {
        if (hint) {
            if (!(sprint_realloc_hinted_integer(buf, buf_len, out_len,
                                                allow_realloc,
                                                *var->val.integer, 'u',
                                                hint, units))) {
                return 0;
            }
        } else {
            char            str[32];
            sprintf(str, "%lu", *var->val.integer);
            if (!snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) str)) {
                return 0;
            }
        }
    } else if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_QUICK_PRINT)) {
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc,
             (const u_char *) enum_string)) {
            return 0;
        }
    } else {
        char            str[32];
        sprintf(str, "(%lu)", *var->val.integer);
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc,
             (const u_char *) enum_string)) {
            return 0;
        }
        if (!snmp_strcat
            (buf, buf_len, out_len, allow_realloc, (const u_char *) str)) {
            return 0;
        }
    }

    if (units) {
        return (snmp_strcat
                (buf, buf_len, out_len, allow_realloc,
                 (const u_char *) " ")
                && snmp_strcat(buf, buf_len, out_len, allow_realloc,
                               (const u_char *) units));
    }
    return 1;
}


/**
 * Set's the printing function printomat in a subtree according
 * it's type
 *
 * @param subtree    The subtree to set.
 */
void
set_function(struct tree *subtree)
{
    subtree->printer = NULL;
    switch (subtree->type) {
    case TYPE_OBJID:
        subtree->printomat = sprint_realloc_object_identifier;
        break;
    case TYPE_OCTETSTR:
        subtree->printomat = sprint_realloc_octet_string;
        break;
    case TYPE_INTEGER:
        subtree->printomat = sprint_realloc_integer;
        break;
    case TYPE_INTEGER32:
        subtree->printomat = sprint_realloc_integer;
        break;
    case TYPE_NETADDR:
        subtree->printomat = sprint_realloc_networkaddress;
        break;
    case TYPE_IPADDR:
        subtree->printomat = sprint_realloc_ipaddress;
        break;
    case TYPE_COUNTER:
        subtree->printomat = sprint_realloc_counter;
        break;
    case TYPE_GAUGE:
        subtree->printomat = sprint_realloc_gauge;
        break;
    case TYPE_TIMETICKS:
        subtree->printomat = sprint_realloc_timeticks;
        break;
    case TYPE_OPAQUE:
        subtree->printomat = sprint_realloc_opaque;
        break;
    case TYPE_NULL:
        subtree->printomat = sprint_realloc_null;
        break;
    case TYPE_BITSTRING:
        subtree->printomat = sprint_realloc_bitstring;
        break;
    case TYPE_NSAPADDRESS:
        subtree->printomat = sprint_realloc_nsapaddress;
        break;
    case TYPE_COUNTER64:
        subtree->printomat = sprint_realloc_counter64;
        break;
    case TYPE_UINTEGER:
        subtree->printomat = sprint_realloc_uinteger;
        break;
    case TYPE_UNSIGNED32:
        subtree->printomat = sprint_realloc_gauge;
        break;
    case TYPE_OTHER:
    default:
        subtree->printomat = sprint_realloc_by_type;
        break;
    }
} 

/*
 * Find all the children of root in the list of nodes.  Link them into the
 * tree and out of the nodes list.
 */
static void do_subtree(struct tree *root, struct node **nodes) {
    struct tree    *tp, *anon_tp = NULL;
    struct tree    *xroot = root;
    struct node    *np, **headp;
    struct node    *oldnp = NULL, *child_list = NULL, *childp = NULL;
    int             hash;
    int            *int_p;

    while (xroot->next_peer && xroot->next_peer->subid == root->subid) {
#if 0
        printf("xroot: %s.%s => %s\n", xroot->parent->label, xroot->label,
               xroot->next_peer->label);
#endif
        xroot = xroot->next_peer;
    }

    tp = root;
    headp = &nbuckets[NBUCKET(name_hash(tp->label))];
    /*
     * Search each of the nodes for one whose parent is root, and
     * move each into a separate list.
     */
    for (np = *headp; np; np = np->next) {
        if (!label_compare(tp->label, np->parent)) {
            /*
             * take this node out of the node list 
             */
            if (oldnp == NULL) {
                *headp = np->next;      /* fix root of node list */
            } else {
                oldnp->next = np->next; /* link around this node */
            }
            if (child_list)
                childp->next = np;
            else
                child_list = np;
            childp = np;
        } else {
            oldnp = np;
        }

    }
    if (childp)
        childp->next = NULL;
    /*
     * Take each element in the child list and place it into the tree.
     */
    for (np = child_list; np; np = np->next) {
        struct tree    *otp = NULL;
        struct tree    *xxroot = xroot;
        anon_tp = NULL;
        tp = xroot->child_list;

        if (np->subid == -1) {
            /*
             * name ::= { parent } 
             */
            np->subid = xroot->subid;
            tp = xroot;
            xxroot = xroot->parent;
        }

        while (tp) {
            if (tp->subid == np->subid)
                break;
            else {
                otp = tp;
                tp = tp->next_peer;
            }
        }
        if (tp) {
            if (!label_compare(tp->label, np->label)) {
                /*
                 * Update list of modules 
                 */
                int_p =
                    (int *) malloc((tp->number_modules + 1) * sizeof(int));
                if (int_p == NULL)
                    return;
                memcpy(int_p, tp->module_list,
                       tp->number_modules * sizeof(int));
                int_p[tp->number_modules] = np->modid;
                if (tp->number_modules > 1)
                    free((char *) tp->module_list);
                ++tp->number_modules;
                tp->module_list = int_p;

                if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIB_REPLACE)) {
                    /*
                     * Replace from node 
                     */
                    tree_from_node(tp, np);
                }
                /*
                 * Handle children 
                 */
                do_subtree(tp, nodes);
                continue;
            }
            if (!strncmp(np->label, ANON, ANON_LEN) ||
                !strncmp(tp->label, ANON, ANON_LEN)) {
                anon_tp = tp;   /* Need to merge these two trees later */
            } else if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
					  NETSNMP_DS_LIB_MIB_WARNINGS)) {
                snmp_log(LOG_WARNING,
                         "Warning: %s.%ld is both %s and %s (%s)\n",
                         root->label, np->subid, tp->label, np->label,
                         File);
	    }
        }

        tp = (struct tree *) calloc(1, sizeof(struct tree));
        if (tp == NULL)
            return;
        tp->parent = xxroot;
        tp->modid = np->modid;
        tp->number_modules = 1;
        tp->module_list = &(tp->modid);
        tree_from_node(tp, np);
        tp->next_peer = otp ? otp->next_peer : xxroot->child_list;
        if (otp)
            otp->next_peer = tp;
        else
            xxroot->child_list = tp;
        hash = NBUCKET(name_hash(tp->label));
        tp->next = tbuckets[hash];
        tbuckets[hash] = tp;
        do_subtree(tp, nodes);

        if (anon_tp) {
            if (!strncmp(tp->label, ANON, ANON_LEN)) {
                /*
                 * The new node is anonymous,
                 *  so merge it with the existing one.
                 */
                merge_anon_children(tp, anon_tp);

                /*
                 * unlink and destroy tp 
                 */
                unlink_tree(tp);
                free_tree(tp);
            } else if (!strncmp(anon_tp->label, ANON, ANON_LEN)) {
                struct tree    *ntp;
                /*
                 * The old node was anonymous,
                 *  so merge it with the existing one,
                 *  and fill in the full information.
                 */
                merge_anon_children(anon_tp, tp);

                /*
                 * unlink anon_tp from the hash 
                 */
                unlink_tbucket(anon_tp);

                /*
                 * get rid of old contents of anon_tp 
                 */
                free_partial_tree(anon_tp, FALSE);

                /*
                 * put in the current information 
                 */
                anon_tp->label = tp->label;
                anon_tp->child_list = tp->child_list;
                anon_tp->modid = tp->modid;
                anon_tp->tc_index = tp->tc_index;
                anon_tp->type = tp->type;
                anon_tp->enums = tp->enums;
                anon_tp->indexes = tp->indexes;
                anon_tp->augments = tp->augments;
                anon_tp->varbinds = tp->varbinds;
                anon_tp->ranges = tp->ranges;
                anon_tp->hint = tp->hint;
                anon_tp->units = tp->units;
                anon_tp->description = tp->description;
                anon_tp->reference = tp->reference;
                anon_tp->defaultValue = tp->defaultValue;
                anon_tp->parent = tp->parent;

                set_function(anon_tp);

                /*
                 * update parent pointer in moved children 
                 */
                ntp = anon_tp->child_list;
                while (ntp) {
                    ntp->parent = anon_tp;
                    ntp = ntp->next_peer;
                }

                /*
                 * hash in anon_tp in its new place 
                 */
                hash = NBUCKET(name_hash(anon_tp->label));
                anon_tp->next = tbuckets[hash];
                tbuckets[hash] = anon_tp;

                /*
                 * unlink and destroy tp 
                 */
                unlink_tbucket(tp);
                unlink_tree(tp);
                free(tp);
            } else {
                /*
                 * Uh?  One of these two should have been anonymous! 
                 */
                if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_MIB_WARNINGS)) {
                    snmp_log(LOG_WARNING, "Warning: expected anonymous node (either %s or %s) in %s\n", tp->label, anon_tp->label, File);
		}
            }
            anon_tp = NULL;
        }
    }
    /*
     * free all nodes that were copied into tree 
     */
    oldnp = NULL;
    for (np = child_list; np; np = np->next) {
        if (oldnp)
            free_node(oldnp);
        oldnp = np;
    }
    if (oldnp)
        free_node(oldnp);
}

/*
 * module_name - copy module name to user buffer, return ptr to same.
 */
char* module_name(int modid, char *cp) {
    struct module  *mp;

    for (mp = module_head; mp; mp = mp->next)
        if (mp->modid == modid) {
            strcpy(cp, mp->name);
            return (cp);
        }

//    if (modid != -1) DEBUGMSGTL(("parse-mibs", "Module %d not found\n", modid));
    sprintf(cp, "#%d", modid);
    return (cp);
}
 
static int      dodebug = NETSNMP_ALWAYS_DEBUG; 
int snmp_get_do_debugging(void) {
    return dodebug;
} 

static void do_linkup(struct module *mp, struct node *np) {
    struct module_import *mip;
    struct node    *onp, *oldp, *newp;
    struct tree    *tp;
    int             i, more;
    /*
     * All modules implicitly import
     *   the roots of the tree
     */
    if (snmp_get_do_debugging() > 1)
        dump_module_list();
//    DEBUGMSGTL(("parse-mibs", "Processing IMPORTS for module %d %s\n", mp->modid, mp->name));
    if (mp->no_imports == 0) {
        mp->no_imports = NUMBER_OF_ROOT_NODES;
        mp->imports = root_imports;
    }

    /*
     * Build the tree
     */
    init_node_hash(np);
    for (i = 0, mip = mp->imports; i < mp->no_imports; ++i, ++mip) {
        char            modbuf[256];
//        DEBUGMSGTL(("parse-mibs", "  Processing import: %s\n", mip->label));
        if (get_tc_index(mip->label, mip->modid) != -1)
            continue;
        tp = find_tree_node(mip->label, mip->modid);
        if (!tp) {
                snmp_log(LOG_WARNING,
                         "Did not find '%s' in module %s (%s)\n",
                         mip->label, module_name(mip->modid, modbuf),
                         File);
            continue;
        }
        do_subtree(tp, &np);
    }

    /*
     * If any nodes left over,
     *   check that they're not the result of a "fully qualified"
     *   name, and then add them to the list of orphans
     */

    if (!np)
        return;
    for (tp = tree_head; tp; tp = tp->next_peer)
        do_subtree(tp, &np);
    if (!np)
        return;

    /*
     * quietly move all internal references to the orphan list 
     */
    oldp = orphan_nodes;
    do {
        for (i = 0; i < NHASHSIZE; i++)
            for (onp = nbuckets[i]; onp; onp = onp->next) {
                struct node    *op = NULL;
                int             hash = NBUCKET(name_hash(onp->label));
                np = nbuckets[hash];
                while (np) {
                    if (label_compare(onp->label, np->parent)) {
                        op = np;
                        np = np->next;
                    } else {
                        if (op)
                            op->next = np->next;
                        else
                            nbuckets[hash] = np->next;
                        np->next = orphan_nodes;
                        orphan_nodes = np;
                        op = NULL;
                        np = nbuckets[hash];
                    }
                }
            }
        newp = orphan_nodes;
        more = 0;
        for (onp = orphan_nodes; onp != oldp; onp = onp->next) {
            struct node    *op = NULL;
            int             hash = NBUCKET(name_hash(onp->label));
            np = nbuckets[hash];
            while (np) {
                if (label_compare(onp->label, np->parent)) {
                    op = np;
                    np = np->next;
                } else {
                    if (op)
                        op->next = np->next;
                    else
                        nbuckets[hash] = np->next;
                    np->next = orphan_nodes;
                    orphan_nodes = np;
                    op = NULL;
                    np = nbuckets[hash];
                    more = 1;
                }
            }
        }
        oldp = newp;
    } while (more);

    /*
     * complain about left over nodes 
     */
    for (np = orphan_nodes; np && np->next; np = np->next);     /* find the end of the orphan list */
    for (i = 0; i < NHASHSIZE; i++)
        if (nbuckets[i]) {
            if (orphan_nodes)
                onp = np->next = nbuckets[i];
            else
                onp = orphan_nodes = nbuckets[i];
            nbuckets[i] = NULL;
            while (onp) {
                snmp_log(LOG_WARNING,
                         "Unlinked OID in %s: %s ::= { %s %ld }\n",
                         (mp->name ? mp->name : "<no module>"),
                         (onp->label ? onp->label : "<no label>"),
                         (onp->parent ? onp->parent : "<no parent>"),
                         onp->subid);
		 snmp_log(LOG_WARNING,
			  "Undefined identifier: %s near line %d of %s\n",
			  (onp->parent ? onp->parent : "<no parent>"),
			  onp->lineno, onp->filename);
                np = onp;
                onp = onp->next;
            }
        }
    return;
} 

static void build_translation_table(void) {
    int             count;

    for (count = 0; count < 256; count++) {
        switch (count) {
        case OBJID:
            translation_table[count] = TYPE_OBJID;
            break;
        case OCTETSTR:
            translation_table[count] = TYPE_OCTETSTR;
            break;
        case INTEGER:
            translation_table[count] = TYPE_INTEGER;
            break;
        case NETADDR:
            translation_table[count] = TYPE_NETADDR;
            break;
        case IPADDR:
            translation_table[count] = TYPE_IPADDR;
            break;
        case COUNTER:
            translation_table[count] = TYPE_COUNTER;
            break;
        case GAUGE:
            translation_table[count] = TYPE_GAUGE;
            break;
        case TIMETICKS:
            translation_table[count] = TYPE_TIMETICKS;
            break;
        case KW_OPAQUE:
            translation_table[count] = TYPE_OPAQUE;
            break;
        case NUL:
            translation_table[count] = TYPE_NULL;
            break;
        case COUNTER64:
            translation_table[count] = TYPE_COUNTER64;
            break;
        case BITSTRING:
            translation_table[count] = TYPE_BITSTRING;
            break;
        case NSAPADDRESS:
            translation_table[count] = TYPE_NSAPADDRESS;
            break;
        case INTEGER32:
            translation_table[count] = TYPE_INTEGER32;
            break;
        case UINTEGER32:
            translation_table[count] = TYPE_UINTEGER;
            break;
        case UNSIGNED32:
            translation_table[count] = TYPE_UNSIGNED32;
            break;
        case TRAPTYPE:
            translation_table[count] = TYPE_TRAPTYPE;
            break;
        case NOTIFTYPE:
            translation_table[count] = TYPE_NOTIFTYPE;
            break;
        case NOTIFGROUP:
            translation_table[count] = TYPE_NOTIFGROUP;
            break;
        case OBJGROUP:
            translation_table[count] = TYPE_OBJGROUP;
            break;
        case MODULEIDENTITY:
            translation_table[count] = TYPE_MODID;
            break;
        case OBJIDENTITY:
            translation_table[count] = TYPE_OBJIDENTITY;
            break;
        case AGENTCAP:
            translation_table[count] = TYPE_AGENTCAP;
            break;
        case COMPLIANCE:
            translation_table[count] = TYPE_MODCOMP;
            break;
        default:
            translation_table[count] = TYPE_OTHER;
            break;
        }
    }
} 

static void init_tree_roots(void) {
    struct tree    *tp, *lasttp;
    int             base_modid;
    int             hash;

    base_modid = which_module("SNMPv2-SMI");
    if (base_modid == -1)
        base_modid = which_module("RFC1155-SMI");
    if (base_modid == -1)
        base_modid = which_module("RFC1213-MIB");

    /*
     * build root node 
     */
    tp = (struct tree *) calloc(1, sizeof(struct tree));
    if (tp == NULL)
        return;
    tp->label = strdup("joint-iso-ccitt");
    tp->modid = base_modid;
    tp->number_modules = 1;
    tp->module_list = &(tp->modid);
    tp->subid = 2;
    tp->tc_index = -1;
    set_function(tp);           /* from mib.c */
    hash = NBUCKET(name_hash(tp->label));
    tp->next = tbuckets[hash];
    tbuckets[hash] = tp;
    lasttp = tp;
    root_imports[0].label = strdup(tp->label);
    root_imports[0].modid = base_modid;

    /*
     * build root node 
     */
    tp = (struct tree *) calloc(1, sizeof(struct tree));
    if (tp == NULL)
        return;
    tp->next_peer = lasttp;
    tp->label = strdup("ccitt");
    tp->modid = base_modid;
    tp->number_modules = 1;
    tp->module_list = &(tp->modid);
    tp->subid = 0;
    tp->tc_index = -1;
    set_function(tp);           /* from mib.c */
    hash = NBUCKET(name_hash(tp->label));
    tp->next = tbuckets[hash];
    tbuckets[hash] = tp;
    lasttp = tp;
    root_imports[1].label = strdup(tp->label);
    root_imports[1].modid = base_modid;

    /*
     * build root node 
     */
    tp = (struct tree *) calloc(1, sizeof(struct tree));
    if (tp == NULL)
        return;
    tp->next_peer = lasttp;
    tp->label = strdup("iso");
    tp->modid = base_modid;
    tp->number_modules = 1;
    tp->module_list = &(tp->modid);
    tp->subid = 1;
    tp->tc_index = -1;
    set_function(tp);           /* from mib.c */
    hash = NBUCKET(name_hash(tp->label));
    tp->next = tbuckets[hash];
    tbuckets[hash] = tp;
    lasttp = tp;
    root_imports[2].label = strdup(tp->label);
    root_imports[2].modid = base_modid;

    tree_head = tp;
} 

void netsnmp_init_mib_internals(void) {
    register struct tok *tp;
    register int    b, i;
    int             max_modc;

    if (tree_head)
        return;

    /*
     * Set up hash list of pre-defined tokens
     */
    memset(buckets, 0, sizeof(buckets));
    for (tp = tokens; tp->name; tp++) {
        tp->hash = name_hash(tp->name);
        b = BUCKET(tp->hash);
        if (buckets[b])
            tp->next = buckets[b];      /* BUG ??? */
        buckets[b] = tp;
    }

    /*
     * Initialise other internal structures
     */

    max_modc = sizeof(module_map) / sizeof(module_map[0]) - 1;
    for (i = 0; i < max_modc; ++i)
        module_map[i].next = &(module_map[i + 1]);
    module_map[max_modc].next = NULL;
    module_map_head = module_map;

    memset(nbuckets, 0, sizeof(nbuckets));
    memset(tbuckets, 0, sizeof(tbuckets));
    memset(tclist, 0, MAXTC * sizeof(struct tc));
    build_translation_table();
    init_tree_roots();          /* Set up initial roots */
    /*
     * Relies on 'add_mibdir' having set up the modules 
     */
} 
/*
 *  Read in the named module
 *      Returns the root of the whole tree
 *      (by analogy with 'read_mib')
 */
static int read_module_internal(const char *name) {
    struct module  *mp;
    FILE           *fp;
    struct node    *np;

    netsnmp_init_mib_internals();

    for (mp = module_head; mp; mp = mp->next)
        if (!label_compare(mp->name, name)) {
            const char     *oldFile = File;
            int             oldLine = mibLine;
            int             oldModule = current_module;

            if (mp->no_imports != -1) {
//                DEBUGMSGTL(("parse-mibs", "Module %s already loaded\n", name));
                return MODULE_ALREADY_LOADED;
            }
            if ((fp = fopen(mp->file, "r")) == NULL) {
                int rval;
                if (errno == ENOTDIR || errno == ENOENT)
                    rval = MODULE_NOT_FOUND;
                else
                    rval = MODULE_LOAD_FAILED;
                snmp_log_perror(mp->file);
                return rval;
            }
#ifdef HAVE_FLOCKFILE
            flockfile(fp);
#endif
            mp->no_imports = 0; /* Note that we've read the file */
            File = mp->file;
            mibLine = 1;
            current_module = mp->modid;
            /*
             * Parse the file
             */
            np = parse(fp, NULL);
#ifdef HAVE_FUNLOCKFILE
            funlockfile(fp);
#endif
            fclose(fp);
            File = oldFile;
            mibLine = oldLine;
            current_module = oldModule;
            if ((np == NULL) && (gMibError == MODULE_SYNTAX_ERROR) )
                return MODULE_SYNTAX_ERROR;
            return MODULE_LOADED_OK;
        }

    return MODULE_NOT_FOUND;
} 

static int read_module_replacements(const char *name) {
    struct module_compatability *mcp;

    for (mcp = module_map_head; mcp; mcp = mcp->next) {
        if (!label_compare(mcp->old_module, name)) {
            if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIB_WARNINGS)) { 
                snmp_log(LOG_WARNING, "Loading replacement module %s for %s (%s)\n", mcp->new_module, name, File);
	    }
            (void) netsnmp_read_module(mcp->new_module);
            return 1;
        }
    }
    return 0;
}

static int read_import_replacements(const char *old_module_name, struct module_import *identifier) {
    struct module_compatability *mcp;

    /*
     * Look for matches first
     */
    for (mcp = module_map_head; mcp; mcp = mcp->next) {
        if (!label_compare(mcp->old_module, old_module_name)) {

            if (                /* exact match */
                   (mcp->tag_len == 0 &&
                    (mcp->tag == NULL ||
                     !label_compare(mcp->tag, identifier->label))) ||
                   /*
                    * prefix match 
                    */
                   (mcp->tag_len != 0 &&
                    !strncmp(mcp->tag, identifier->label, mcp->tag_len))
                ) {

                if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIB_WARNINGS)) {
//                    snmp_log(LOG_WARNING, "Importing %s from replacement module %s instead of %s (%s)\n", identifier->label, mcp->new_module, old_module_name, File)
									;
		}
                (void) netsnmp_read_module(mcp->new_module);
                identifier->modid = which_module(mcp->new_module);
                return 1;         /* finished! */
            }
        }
    }

    /*
     * If no exact match, load everything relevant
     */
    return read_module_replacements(old_module_name);
} 

/*
 * function : netsnmp_set_mib_directory
 *            - This function sets the string of the directories
 *              from which the MIB modules will be searched or
 *              loaded.
 * arguments: const char *dir, which are the directories
 *              from which the MIB modules will be searched or
 *              loaded.
 * returns  : -
 */
void netsnmp_set_mib_directory(const char *dir) {
    const char *newdir;
    char *olddir, *tmpdir = NULL;

//    DEBUGTRACE;
    if (NULL == dir) {
        return;
    }
    
    olddir = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIBDIRS);
    if (olddir) {
        if ((*dir == '+') || (*dir == '-')) {
            /** New dir starts with '+', thus we add it. */
            tmpdir = (char *)malloc(strlen(dir) + strlen(olddir) + 2);
            if (!tmpdir) {
//                DEBUGMSGTL(("read_config:initmib", "set mibdir malloc failed"));
                return;
            }
            if (*dir++ == '+')
                sprintf(tmpdir, "%s%c%s", olddir, ENV_SEPARATOR_CHAR, dir);
            else
                sprintf(tmpdir, "%s%c%s", dir, ENV_SEPARATOR_CHAR, olddir);
            newdir = tmpdir;
        } else {
            newdir = dir;
        }
    } else {
        /** If dir starts with '+' skip '+' it. */
        newdir = ((*dir == '+') ? ++dir : dir);
    }
    netsnmp_ds_set_string(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIBDIRS,newdir);

    /** set_string calls strdup, so if we allocated memory, free it */
    if (tmpdir == newdir) {
        SNMP_FREE(tmpdir);
    }
}



int setenv(const char *name, const char *value, int overwrite) {
    char           *cp;
    int             ret;

    if (overwrite == 0) {
        if (getenv(name))
            return 0;
    }
    cp = (char *) malloc(strlen(name) + strlen(value) + 2);
    if (cp == NULL)
        return -1;
    sprintf(cp, "%s=%s", name, value);
    ret = putenv(cp);
#ifdef WIN32
    free(cp);
#endif
    return ret;
} 

/**
 * Non Windows:  Returns a pointer to the desired environment variable  
 *               or NULL if the environment variable does not exist.  
 *               
 * Windows:      Returns a pointer to the desired environment variable  
 *               if it exists.  If it does not, the variable is looked up
 *               in the registry in HKCU\\Net-SNMP or HKLM\\Net-SNMP
 *               (whichever it finds first) and stores the result in the 
 *               environment variable.  It then returns a pointer to 
 *               environment variable.
 */

char *netsnmp_getenv(const char *name) {
#if !defined (WIN32) && !defined (cygwin)
  return (getenv(name));
#else
  char *temp = NULL;  
  HKEY hKey;
  unsigned char * key_value = NULL;
  DWORD key_value_size = 0;
  DWORD key_value_type = 0;
  DWORD getenv_worked = 0;

  if (!(name))
    return NULL;
  
  /* Try environment variable first */ 
  temp = getenv(name);
  if (temp) {
    getenv_worked = 1;
  }
  
  /* Next try HKCU */
  if (temp == NULL)
  {
    if (getenv("SNMP_IGNORE_WINDOWS_REGISTRY"))
      return NULL;

    if (RegOpenKeyExA(
          HKEY_CURRENT_USER, 
          "SOFTWARE\\Net-SNMP", 
          0, 
          KEY_QUERY_VALUE, 
          &hKey) == ERROR_SUCCESS) {   
      
      if (RegQueryValueExA(
            hKey, 
            name, 
            NULL, 
            &key_value_type, 
            NULL,               /* Just get the size */
            &key_value_size) == ERROR_SUCCESS) {

        SNMP_FREE(key_value);

        /* Allocate memory needed +1 to allow RegQueryValueExA to NULL terminate the
         * string data in registry is missing one (which is unlikely).
         */
        key_value = (unsigned char *)malloc((sizeof(char) * key_value_size)+sizeof(char));
        
        if (RegQueryValueExA(
              hKey, 
              name, 
              NULL, 
              &key_value_type, 
              key_value, 
              &key_value_size) == ERROR_SUCCESS) {
        }
        temp = (char *) key_value;
      }
      RegCloseKey(hKey);
    }
  }

  /* Next try HKLM */
  if (temp == NULL)
  {
    if (RegOpenKeyExA(
          HKEY_LOCAL_MACHINE, 
          "SOFTWARE\\Net-SNMP", 
          0, 
          KEY_QUERY_VALUE, 
          &hKey) == ERROR_SUCCESS) {   
      
      if (RegQueryValueExA(
            hKey, 
            name, 
            NULL, 
            &key_value_type, 
            NULL,               /* Just get the size */
            &key_value_size) == ERROR_SUCCESS) {

        SNMP_FREE(key_value);

        /* Allocate memory needed +1 to allow RegQueryValueExA to NULL terminate the
         * string data in registry is missing one (which is unlikely).
         */
        key_value = (unsigned char *)malloc((sizeof(char) * key_value_size)+sizeof(char));
        
        if (RegQueryValueExA(
              hKey, 
              name, 
              NULL, 
              &key_value_type, 
              key_value, 
              &key_value_size) == ERROR_SUCCESS) {
        }
        temp = (char *) key_value;

      }
      RegCloseKey(hKey);
    }
  }
  
  if (temp && !getenv_worked) {
    setenv(name, temp, 1);
    SNMP_FREE(temp);
  }


  return(getenv(name));
#endif
} 

/*
 * function : netsnmp_get_mib_directory
 *            - This function returns a string of the directories
 *              from which the MIB modules will be searched or
 *              loaded.
 *              If the value still does not exists, it will be made
 *              from the evironment variable 'MIBDIRS' and/or the
 *              default.
 * arguments: -
 * returns  : char * of the directories in which the MIB modules
 *            will be searched/loaded.
 */

char *netsnmp_get_mib_directory(void) {
    char *dir;

//    DEBUGTRACE;
    dir = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIBDIRS);
    if (dir == NULL) {
//        DEBUGMSGTL(("get_mib_directory", "no mib directories set\n"));

        /** Check if the environment variable is set */
        dir = netsnmp_getenv("MIBDIRS");
        if (dir == NULL) {
//            DEBUGMSGTL(("get_mib_directory", "no mib directories set by environment\n"));
            /** Not set use hard coded path */
            if (confmibdir == NULL) {
//                DEBUGMSGTL(("get_mib_directory", "no mib directories set by config\n"));
                netsnmp_set_mib_directory(NETSNMP_DEFAULT_MIBDIRS);
            }
            else if ((*confmibdir == '+') || (*confmibdir == '-')) {
//                DEBUGMSGTL(("get_mib_directory", "mib directories set by config (but added)\n"));
                netsnmp_set_mib_directory(NETSNMP_DEFAULT_MIBDIRS);
                netsnmp_set_mib_directory(confmibdir);
            }
            else {
//                DEBUGMSGTL(("get_mib_directory", "mib directories set by config\n"));
                netsnmp_set_mib_directory(confmibdir);
            }
        } else if ((*dir == '+') || (*dir == '-')) {
//            DEBUGMSGTL(("get_mib_directory", "mib directories set by environment (but added)\n"));
            netsnmp_set_mib_directory(NETSNMP_DEFAULT_MIBDIRS);
            netsnmp_set_mib_directory(dir);
        } else {
//            DEBUGMSGTL(("get_mib_directory", "mib directories set by environment\n"));
            netsnmp_set_mib_directory(dir);
        }
        dir = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIBDIRS);
    }
//    DEBUGMSGTL(("get_mib_directory", "mib directories set '%s'\n", dir));
    return(dir);
}

static void print_module_not_found(const char *cp) {
    if (first_err_module) {
        snmp_log(LOG_ERR, "MIB search path: %s\n", netsnmp_get_mib_directory());
        first_err_module = 0;
    }
    if (!last_err_module || strcmp(cp, last_err_module))
        print_error("Cannot find module", cp, CONTINUE);
    if (last_err_module)
        free(last_err_module);
    last_err_module = strdup(cp);
}
 

/*
 * Parses a module import clause
 *   loading any modules referenced
 */
static void parse_imports(FILE * fp) {
    register int    type;
    char            token[MAXTOKEN];
    char            modbuf[256];
#define MAX_IMPORTS	256
    struct module_import import_list[MAX_IMPORTS];
    int             this_module;
    struct module  *mp;

    int             import_count = 0;   /* Total number of imported descriptors */
    int             i = 0, old_i;       /* index of first import from each module */

    type = get_token(fp, token, MAXTOKEN);

    /*
     * Parse the IMPORTS clause
     */
    while (type != SEMI && type != ENDOFFILE) {
        if (type == LABEL) {
            if (import_count == MAX_IMPORTS) {
                print_error("Too many imported symbols", token, type);
                do {
                    type = get_token(fp, token, MAXTOKEN);
                } while (type != SEMI && type != ENDOFFILE);
                return;
            }
            import_list[import_count++].label = strdup(token);
        } else if (type == FROM) {
            type = get_token(fp, token, MAXTOKEN);
            if (import_count == i) {    /* All imports are handled internally */
                type = get_token(fp, token, MAXTOKEN);
                continue;
            }
            this_module = which_module(token);

            for (old_i = i; i < import_count; ++i)
                import_list[i].modid = this_module;

            /*
             * Recursively read any pre-requisite modules
             */
            if (read_module_internal(token) == MODULE_NOT_FOUND) {
		int found = 0;
                for (; old_i < import_count; ++old_i) {
                    found += read_import_replacements(token, &import_list[old_i]);
                }
		if (!found)
		    print_module_not_found(token);
            }
        }
        type = get_token(fp, token, MAXTOKEN);
    }

    /*
     * Save the import information
     *   in the global module table
     */
    for (mp = module_head; mp; mp = mp->next)
        if (mp->modid == current_module) {
            if (import_count == 0)
                return;
            if (mp->imports && (mp->imports != root_imports)) {
                /*
                 * this can happen if all modules are in one source file. 
                 */
                for (i = 0; i < mp->no_imports; ++i) {
//                    DEBUGMSGTL(("parse-mibs", "#### freeing Module %d '%s' %d\n", mp->modid, mp->imports[i].label, mp->imports[i].modid));
                    free((char *) mp->imports[i].label);
                }
                free((char *) mp->imports);
            }
            mp->imports = (struct module_import *)
                calloc(import_count, sizeof(struct module_import));
            if (mp->imports == NULL)
                return;
            for (i = 0; i < import_count; ++i) {
                mp->imports[i].label = import_list[i].label;
                mp->imports[i].modid = import_list[i].modid;
//                DEBUGMSGTL(("parse-mibs", "#### adding Module %d '%s' %d\n", mp->modid, mp->imports[i].label, mp->imports[i].modid));
            }
            mp->no_imports = import_count;
            return;
        }

    /*
     * Shouldn't get this far
     */
    print_module_not_found(module_name(current_module, modbuf));
    return;
}
 
static struct node *
alloc_node(int modid)
{
    struct node    *np;
    np = (struct node *) calloc(1, sizeof(struct node));
    if (np) {
        np->tc_index = -1;
        np->modid = modid;
	np->filename = strdup(File);
	np->lineno = mibLine;
    }
    return np;
}
 

/*
 * Parses a MACRO definition
 * Expect BEGIN, discard everything to end.
 * Returns 0 on error.
 */
static struct node *
parse_macro(FILE * fp, char *name)
{
    register int    type;
    char            token[MAXTOKEN];
    struct node    *np;
    int             iLine = mibLine;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, sizeof(token));
    while (type != EQUALS && type != ENDOFFILE) {
        type = get_token(fp, token, sizeof(token));
    }
    if (type != EQUALS) {
        if (np)
            free_node(np);
        return NULL;
    }
    while (type != BEGIN && type != ENDOFFILE) {
        type = get_token(fp, token, sizeof(token));
    }
    if (type != BEGIN) {
        if (np)
            free_node(np);
        return NULL;
    }
    while (type != END && type != ENDOFFILE) {
        type = get_token(fp, token, sizeof(token));
    }
    if (type != END) {
        if (np)
            free_node(np);
        return NULL;
    }

    if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_MIB_WARNINGS)) {
        snmp_log(LOG_WARNING, "%s MACRO (lines %d..%d parsed and ignored).\n", name, iLine, mibLine);
    }

    return np;
} 

static void new_module(const char *name, const char *file) {
    struct module  *mp;

    for (mp = module_head; mp; mp = mp->next)
        if (!label_compare(mp->name, name)) {
//            DEBUGMSGTL(("parse-mibs", "  Module %s already noted\n", name));
            /*
             * Not the same file 
             */
            if (label_compare(mp->file, file)) {
//                DEBUGMSGTL(("parse-mibs", "    %s is now in %s\n", name, file));
                if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_MIB_WARNINGS)) {
                    snmp_log(LOG_WARNING, "Warning: Module %s was in %s now is %s\n", name, mp->file, file);
		}

                /*
                 * Use the new one in preference 
                 */
                free(mp->file);
                mp->file = strdup(file);
            }
            return;
        }

    /*
     * Add this module to the list 
     */
//    DEBUGMSGTL(("parse-mibs", "  Module %d %s is in %s\n", max_module, name, file));
    mp = (struct module *) calloc(1, sizeof(struct module));
    if (mp == NULL)
        return;
    mp->name = strdup(name);
    mp->file = strdup(file);
    mp->imports = NULL;
    mp->no_imports = -1;        /* Not yet loaded */
    mp->modid = max_module;
    ++max_module;

    mp->next = module_head;     /* Or add to the *end* of the list? */
    module_head = mp;
} 

static struct enum_list *
copy_enums(struct enum_list *sp)
{
    struct enum_list *xp = NULL, **spp = &xp;

    while (sp) {
        *spp = (struct enum_list *) calloc(1, sizeof(struct enum_list));
        if (!*spp)
            break;
        (*spp)->label = strdup(sp->label);
        (*spp)->value = sp->value;
        spp = &(*spp)->next;
        sp = sp->next;
    }
    return (xp);
}
 
static struct range_list *
copy_ranges(struct range_list *sp)
{
    struct range_list *xp = NULL, **spp = &xp;

    while (sp) {
        *spp = (struct range_list *) calloc(1, sizeof(struct range_list));
        if (!*spp)
            break;
        (*spp)->low = sp->low;
        (*spp)->high = sp->high;
        spp = &(*spp)->next;
        sp = sp->next;
    }
    return (xp);
}
 

static int
get_tc(const char *descriptor,
       int modid,
       int *tc_index,
       struct enum_list **ep, struct range_list **rp, char **hint)
{
    int             i;
    struct tc      *tcp;

    i = get_tc_index(descriptor, modid);
    if (tc_index)
        *tc_index = i;
    if (i != -1) {
        tcp = &tclist[i];
        if (ep) {
            free_enums(ep);
            *ep = copy_enums(tcp->enums);
        }
        if (rp) {
            free_ranges(rp);
            *rp = copy_ranges(tcp->ranges);
        }
        if (hint) {
            if (*hint)
                free(*hint);
            *hint = (tcp->hint ? strdup(tcp->hint) : NULL);
        }
        return tcp->type;
    }
    return LABEL;
}
 
			 /*
 * Parses an enumeration list of the form:
 *        { label(value) label(value) ... }
 * The initial { has already been parsed.
 * Returns NULL on error.
 */

static struct enum_list *
parse_enumlist(FILE * fp, struct enum_list **retp)
{
    register int    type;
    char            token[MAXTOKEN];
    struct enum_list *ep = NULL, **epp = &ep;

    free_enums(retp);

    while ((type = get_token(fp, token, MAXTOKEN)) != ENDOFFILE) {
        if (type == RIGHTBRACKET)
            break;
        /* some enums use "deprecated" to indicate a no longer value label */
        /* (EG: IP-MIB's IpAddressStatusTC) */
        if (type == LABEL || type == DEPRECATED) {
            /*
             * this is an enumerated label 
             */
            *epp =
                (struct enum_list *) calloc(1, sizeof(struct enum_list));
            if (*epp == NULL)
                return (NULL);
            /*
             * a reasonable approximation for the length 
             */
            (*epp)->label = strdup(token);
            type = get_token(fp, token, MAXTOKEN);
            if (type != LEFTPAREN) {
                print_error("Expected \"(\"", token, type);
                return NULL;
            }
            type = get_token(fp, token, MAXTOKEN);
            if (type != NUMBER) {
                print_error("Expected integer", token, type);
                return NULL;
            }
            (*epp)->value = strtol(token, NULL, 10);
            type = get_token(fp, token, MAXTOKEN);
            if (type != RIGHTPAREN) {
                print_error("Expected \")\"", token, type);
                return NULL;
            }
            epp = &(*epp)->next;
        }
    }
    if (type == ENDOFFILE) {
        print_error("Expected \"}\"", token, type);
        return NULL;
    }
    *retp = ep;
    return ep;
} 

static struct range_list *
parse_ranges(FILE * fp, struct range_list **retp)
{
    int             low, high;
    char            nexttoken[MAXTOKEN];
    int             nexttype;
    struct range_list *rp = NULL, **rpp = &rp;
    int             size = 0, taken = 1;

    free_ranges(retp);

    nexttype = get_token(fp, nexttoken, MAXTOKEN);
    if (nexttype == SIZE) {
        size = 1;
        taken = 0;
        nexttype = get_token(fp, nexttoken, MAXTOKEN);
        if (nexttype != LEFTPAREN)
            print_error("Expected \"(\" after SIZE", nexttoken, nexttype);
    }

    do {
        if (!taken)
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        else
            taken = 0;
        high = low = strtoul(nexttoken, NULL, 10);
        nexttype = get_token(fp, nexttoken, MAXTOKEN);
        if (nexttype == RANGE) {
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
            errno = 0;
            high = strtoul(nexttoken, NULL, 10);
            if ( errno == ERANGE ) {
                if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
                                       NETSNMP_DS_LIB_MIB_WARNINGS))
                    snmp_log(LOG_WARNING,
                             "Warning: Upper bound not handled correctly (%s != %d): At line %d in %s\n",
                                 nexttoken, high, mibLine, File);
            }
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        }
        *rpp = (struct range_list *) calloc(1, sizeof(struct range_list));
        if (*rpp == NULL)
            break;
        (*rpp)->low = low;
        (*rpp)->high = high;
        rpp = &(*rpp)->next;

    } while (nexttype == BAR);
    if (size) {
        if (nexttype != RIGHTPAREN)
            print_error("Expected \")\" after SIZE", nexttoken, nexttype);
        nexttype = get_token(fp, nexttoken, nexttype);
    }
    if (nexttype != RIGHTPAREN)
        print_error("Expected \")\"", nexttoken, nexttype);

    *retp = rp;
    return rp;
} 

/*
 * struct index_list *
 * getIndexes(FILE *fp):
 *   This routine parses a string like  { blah blah blah } and returns a
 *   list of the strings enclosed within it.
 *
 */
static struct index_list *
getIndexes(FILE * fp, struct index_list **retp)
{
    int             type;
    char            token[MAXTOKEN];
    char            nextIsImplied = 0;

    struct index_list *mylist = NULL;
    struct index_list **mypp = &mylist;

    free_indexes(retp);

    type = get_token(fp, token, MAXTOKEN);

    if (type != LEFTBRACKET) {
        return NULL;
    }

    type = get_token(fp, token, MAXTOKEN);
    while (type != RIGHTBRACKET && type != ENDOFFILE) {
        if ((type == LABEL) || (type & SYNTAX_MASK)) {
            *mypp =
                (struct index_list *) calloc(1, sizeof(struct index_list));
            if (*mypp) {
                (*mypp)->ilabel = strdup(token);
                (*mypp)->isimplied = nextIsImplied;
                mypp = &(*mypp)->next;
                nextIsImplied = 0;
            }
        } else if (type == IMPLIED) {
            nextIsImplied = 1;
        }
        type = get_token(fp, token, MAXTOKEN);
    }

    *retp = mylist;
    return mylist;
} 

/*
 * This routine parses a string like  { blah blah blah } and returns OBJID if
 * it is well formed, and NULL if not.
 */
static int
tossObjectIdentifier(FILE * fp)
{
    int             type;
    char            token[MAXTOKEN];
    int             bracketcount = 1;

    type = get_token(fp, token, MAXTOKEN);

    if (type != LEFTBRACKET)
        return 0;
    while ((type != RIGHTBRACKET || bracketcount > 0) && type != ENDOFFILE) {
        type = get_token(fp, token, MAXTOKEN);
        if (type == LEFTBRACKET)
            bracketcount++;
        else if (type == RIGHTBRACKET)
            bracketcount--;
    }

    if (type == RIGHTBRACKET)
        return OBJID;
    else
        return 0;
} 

/*
 * Takes a list of the form:
 * { iso org(3) dod(6) 1 }
 * and creates several nodes, one for each parent-child pair.
 * Returns 0 on error.
 */
static int
getoid(FILE * fp, struct subid_s *id,   /* an array of subids */
       int length)
{                               /* the length of the array */
    register int    count;
    int             type;
    char            token[MAXTOKEN];

    if ((type = get_token(fp, token, MAXTOKEN)) != LEFTBRACKET) {
        print_error("Expected \"{\"", token, type);
        return 0;
    }
    type = get_token(fp, token, MAXTOKEN);
    for (count = 0; count < length; count++, id++) {
        id->label = NULL;
        id->modid = current_module;
        id->subid = -1;
        if (type == RIGHTBRACKET)
            return count;
        if (type == LABEL) {
            /*
             * this entry has a label 
             */
            id->label = strdup(token);
            type = get_token(fp, token, MAXTOKEN);
            if (type == LEFTPAREN) {
                type = get_token(fp, token, MAXTOKEN);
                if (type == NUMBER) {
                    id->subid = strtoul(token, NULL, 10);
                    if ((type =
                         get_token(fp, token, MAXTOKEN)) != RIGHTPAREN) {
                        print_error("Expected a closing parenthesis",
                                    token, type);
                        return 0;
                    }
                } else {
                    print_error("Expected a number", token, type);
                    return 0;
                }
            } else {
                continue;
            }
        } else if (type == NUMBER) {
            /*
             * this entry  has just an integer sub-identifier 
             */
            id->subid = strtoul(token, NULL, 10);
        } else {
            print_error("Expected label or number", token, type);
            return 0;
        }
        type = get_token(fp, token, MAXTOKEN);
    }
    print_error("Too long OID", token, type);
    return 0;
} 

/*
 * Parse a sequence of object subidentifiers for the given name.
 * The "label OBJECT IDENTIFIER ::=" portion has already been parsed.
 *
 * The majority of cases take this form :
 * label OBJECT IDENTIFIER ::= { parent 2 }
 * where a parent label and a child subidentifier number are specified.
 *
 * Variations on the theme include cases where a number appears with
 * the parent, or intermediate subidentifiers are specified by label,
 * by number, or both.
 *
 * Here are some representative samples :
 * internet        OBJECT IDENTIFIER ::= { iso org(3) dod(6) 1 }
 * mgmt            OBJECT IDENTIFIER ::= { internet 2 }
 * rptrInfoHealth  OBJECT IDENTIFIER ::= { snmpDot3RptrMgt 0 4 }
 *
 * Here is a very rare form :
 * iso             OBJECT IDENTIFIER ::= { 1 }
 *
 * Returns NULL on error.  When this happens, memory may be leaked.
 */
static struct node *
parse_objectid(FILE * fp, char *name)
{
    register int    count;
    register struct subid_s *op, *nop;
    int             length;
    struct subid_s  loid[32];
    struct node    *np, *root = NULL, *oldnp = NULL;
    struct tree    *tp;

    if ((length = getoid(fp, loid, 32)) == 0) {
        print_error("Bad object identifier", NULL, CONTINUE);
        return NULL;
    }

    /*
     * Handle numeric-only object identifiers,
     *  by labelling the first sub-identifier
     */
    op = loid;
    if (!op->label) {
        if (length == 1) {
            print_error("Attempt to define a root oid", name, OBJECT);
            return NULL;
        }
        for (tp = tree_head; tp; tp = tp->next_peer)
            if ((int) tp->subid == op->subid) {
                op->label = strdup(tp->label);
                break;
            }
    }

    /*
     * Handle  "label OBJECT-IDENTIFIER ::= { subid }"
     */
    if (length == 1) {
        op = loid;
        np = alloc_node(op->modid);
        if (np == NULL)
            return (NULL);
        np->subid = op->subid;
        np->label = strdup(name);
        np->parent = op->label;
        return np;
    }

    /*
     * For each parent-child subid pair in the subid array,
     * create a node and link it into the node list.
     */
    for (count = 0, op = loid, nop = loid + 1; count < (length - 1);
         count++, op++, nop++) {
        /*
         * every node must have parent's name and child's name or number 
         */
        /*
         * XX the next statement is always true -- does it matter ?? 
         */
        if (op->label && (nop->label || (nop->subid != -1))) {
            np = alloc_node(nop->modid);
            if (np == NULL)
                return (NULL);
            if (root == NULL)
                root = np;

            np->parent = strdup(op->label);
            if (count == (length - 2)) {
                /*
                 * The name for this node is the label for this entry 
                 */
                np->label = strdup(name);
                if (np->label == NULL) {
                    SNMP_FREE(np->parent);
                    SNMP_FREE(np);
                    return (NULL);
                }
            } else {
                if (!nop->label) {
                    nop->label = (char *) malloc(20 + ANON_LEN);
                    if (nop->label == NULL) {
                        SNMP_FREE(np->parent);
                        SNMP_FREE(np);
                        return (NULL);
                    }
                    sprintf(nop->label, "%s%d", ANON, anonymous++);
                }
                np->label = strdup(nop->label);
            }
            if (nop->subid != -1)
                np->subid = nop->subid;
            else
                print_error("Warning: This entry is pretty silly",
                            np->label, CONTINUE);

            /*
             * set up next entry 
             */
            if (oldnp)
                oldnp->next = np;
            oldnp = np;
        }                       /* end if(op->label... */
    }

    /*
     * free the loid array 
     */
    for (count = 0, op = loid; count < length; count++, op++) {
        if (op->label)
            free(op->label);
    }

    return root;
}

/*
 * Merge the parsed object identifier with the existing node.
 * If there is a problem with the identifier, release the existing node.
 */
static struct node *
merge_parse_objectid(struct node *np, FILE * fp, char *name)
{
    struct node    *nnp;
    /*
     * printf("merge defval --> %s\n",np->defaultValue); 
     */
    nnp = parse_objectid(fp, name);
    if (nnp) {

        /*
         * apply last OID sub-identifier data to the information 
         */
        /*
         * already collected for this node. 
         */
        struct node    *headp, *nextp;
        int             ncount = 0;
        nextp = headp = nnp;
        while (nnp->next) {
            nextp = nnp;
            ncount++;
            nnp = nnp->next;
        }

        np->label = nnp->label;
        np->subid = nnp->subid;
        np->modid = nnp->modid;
        np->parent = nnp->parent;
	if (nnp->filename != NULL) {
	  free(nnp->filename);
	}
        free(nnp);

        if (ncount) {
            nextp->next = np;
            np = headp;
        }
    } else {
        free_node(np);
        np = NULL;
    }

    return np;
} 

/*
 * Parses an OBJECT TYPE macro.
 * Returns 0 on error.
 */
static struct node *
parse_objecttype(FILE * fp, char *name)
{
    register int    type;
    char            token[MAXTOKEN];
    char            nexttoken[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    int             nexttype, tctype;
    register struct node *np;

    type = get_token(fp, token, MAXTOKEN);
    if (type != SYNTAX) {
        print_error("Bad format for OBJECT-TYPE", token, type);
        return NULL;
    }
    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    if (type == OBJECT) {
        type = get_token(fp, token, MAXTOKEN);
        if (type != IDENTIFIER) {
            print_error("Expected IDENTIFIER", token, type);
            free_node(np);
            return NULL;
        }
        type = OBJID;
    }
    if (type == LABEL) {
        int             tmp_index;
        tctype = get_tc(token, current_module, &tmp_index, &np->enums, &np->ranges, &np->hint);
        if (tctype == LABEL &&
            netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
			       NETSNMP_DS_LIB_MIB_WARNINGS) > 1) {
            print_error("Warning: No known translation for type", token,
                        type);
        }
        type = tctype;
        np->tc_index = tmp_index;       /* store TC for later reference */
    }
    np->type = type;
    nexttype = get_token(fp, nexttoken, MAXTOKEN);
    switch (type) {
    case SEQUENCE:
        if (nexttype == OF) {
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
            nexttype = get_token(fp, nexttoken, MAXTOKEN);

        }
        break;
    case INTEGER:
    case INTEGER32:
    case UINTEGER32:
    case UNSIGNED32:
    case COUNTER:
    case GAUGE:
    case BITSTRING:
    case LABEL:
        if (nexttype == LEFTBRACKET) {
            /*
             * if there is an enumeration list, parse it 
             */
            np->enums = parse_enumlist(fp, &np->enums);
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        } else if (nexttype == LEFTPAREN) {
            /*
             * if there is a range list, parse it 
             */
            np->ranges = parse_ranges(fp, &np->ranges);
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        }
        break;
    case OCTETSTR:
    case KW_OPAQUE:
        /*
         * parse any SIZE specification 
         */
        if (nexttype == LEFTPAREN) {
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
            if (nexttype == SIZE) {
                nexttype = get_token(fp, nexttoken, MAXTOKEN);
                if (nexttype == LEFTPAREN) {
                    np->ranges = parse_ranges(fp, &np->ranges);
                    nexttype = get_token(fp, nexttoken, MAXTOKEN);      /* ) */
                    if (nexttype == RIGHTPAREN) {
                        nexttype = get_token(fp, nexttoken, MAXTOKEN);
                        break;
                    }
                }
            }
            print_error("Bad SIZE syntax", token, type);
            free_node(np);
            return NULL;
        }
        break;
    case OBJID:
    case NETADDR:
    case IPADDR:
    case TIMETICKS:
    case NUL:
    case NSAPADDRESS:
    case COUNTER64:
        break;
    default:
        print_error("Bad syntax", token, type);
        free_node(np);
        return NULL;
    }
    if (nexttype == UNITS) {
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
        if (type != QUOTESTRING) {
            print_error("Bad UNITS", quoted_string_buffer, type);
            free_node(np);
            return NULL;
        }
        np->units = strdup(quoted_string_buffer);
        nexttype = get_token(fp, nexttoken, MAXTOKEN);
    }
    if (nexttype != ACCESS) {
        print_error("Should be ACCESS", nexttoken, nexttype);
        free_node(np);
        return NULL;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != READONLY && type != READWRITE && type != WRITEONLY
        && type != NOACCESS && type != READCREATE && type != ACCNOTIFY) {
        print_error("Bad ACCESS type", token, type);
        free_node(np);
        return NULL;
    }
    np->access = type;
    type = get_token(fp, token, MAXTOKEN);
    if (type != STATUS) {
        print_error("Should be STATUS", token, type);
        free_node(np);
        return NULL;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != MANDATORY && type != CURRENT && type != KW_OPTIONAL &&
        type != OBSOLETE && type != DEPRECATED) {
        print_error("Bad STATUS", token, type);
        free_node(np);
        return NULL;
    }
    np->status = type;
    /*
     * Optional parts of the OBJECT-TYPE macro
     */
    type = get_token(fp, token, MAXTOKEN);
    while (type != EQUALS && type != ENDOFFILE) {
        switch (type) {
        case DESCRIPTION:
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);

            if (type != QUOTESTRING) {
                print_error("Bad DESCRIPTION", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
                np->description = strdup(quoted_string_buffer);
            }
            break;

        case REFERENCE:
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            if (type != QUOTESTRING) {
                print_error("Bad REFERENCE", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            np->reference = strdup(quoted_string_buffer);
            break;
        case INDEX:
            if (np->augments) {
                print_error("Cannot have both INDEX and AUGMENTS", token,
                            type);
                free_node(np);
                return NULL;
            }
            np->indexes = getIndexes(fp, &np->indexes);
            if (np->indexes == NULL) {
                print_error("Bad INDEX list", token, type);
                free_node(np);
                return NULL;
            }
            break;
        case AUGMENTS:
            if (np->indexes) {
                print_error("Cannot have both INDEX and AUGMENTS", token,
                            type);
                free_node(np);
                return NULL;
            }
            np->indexes = getIndexes(fp, &np->indexes);
            if (np->indexes == NULL) {
                print_error("Bad AUGMENTS list", token, type);
                free_node(np);
                return NULL;
            }
            np->augments = strdup(np->indexes->ilabel);
            free_indexes(&np->indexes);
            break;
        case DEFVAL:
            /*
             * Mark's defVal section 
             */
            type = get_token(fp, quoted_string_buffer, MAXTOKEN);
            if (type != LEFTBRACKET) {
                print_error("Bad DEFAULTVALUE", quoted_string_buffer,
                            type);
                free_node(np);
                return NULL;
            }

            {
                int             level = 1;
                char            defbuf[512];

                defbuf[0] = 0;
                while (1) {
                    type = get_token(fp, quoted_string_buffer, MAXTOKEN);
                    if ((type == RIGHTBRACKET && --level == 0)
                        || type == ENDOFFILE)
                        break;
                    else if (type == LEFTBRACKET)
                        level++;
                    if (type == QUOTESTRING)
//                        strlcat(defbuf, "\\\"", sizeof(defbuf));
                        strcat(defbuf, "\\\"");
//                    strlcat(defbuf, quoted_string_buffer, sizeof(defbuf));
                    strcat(defbuf, quoted_string_buffer);
                    if (type == QUOTESTRING)
//                        strlcat(defbuf, "\\\"", sizeof(defbuf));
                        strcat(defbuf, "\\\"");
//                    strlcat(defbuf, " ", sizeof(defbuf));
                    strcat(defbuf, " ");
                }

                if (type != RIGHTBRACKET) {
                    print_error("Bad DEFAULTVALUE", quoted_string_buffer,
                                type);
                    free_node(np);
                    return NULL;
                }

                defbuf[strlen(defbuf) - 1] = 0;
                np->defaultValue = strdup(defbuf);
            }

            break;

        case NUM_ENTRIES:
            if (tossObjectIdentifier(fp) != OBJID) {
                print_error("Bad Object Identifier", token, type);
                free_node(np);
                return NULL;
            }
            break;

        default:
            print_error("Bad format of optional clauses", token, type);
            free_node(np);
            return NULL;

        }
        type = get_token(fp, token, MAXTOKEN);
    }
    if (type != EQUALS) {
        print_error("Bad format", token, type);
        free_node(np);
        return NULL;
    }
    return merge_parse_objectid(np, fp, name);
} 

/*
 * Parses an OBJECT GROUP macro.
 * Returns 0 on error.
 *
 * Also parses object-identity, since they are similar (ignore STATUS).
 *   - WJH 10/96
 */
static struct node *
parse_objectgroup(FILE * fp, char *name, int what, struct objgroup **ol)
{
    int             type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    struct node    *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    if (type == what) {
        type = get_token(fp, token, MAXTOKEN);
        if (type != LEFTBRACKET) {
            print_error("Expected \"{\"", token, type);
            goto skip;
        }
        do {
            struct objgroup *o;
            type = get_token(fp, token, MAXTOKEN);
            if (type != LABEL) {
                print_error("Bad identifier", token, type);
                goto skip;
            }
            o = (struct objgroup *) malloc(sizeof(struct objgroup));
            if (!o) {
                print_error("Resource failure", token, type);
                goto skip;
            }
            o->line = mibLine;
            o->name = strdup(token);
            o->next = *ol;
            *ol = o;
            type = get_token(fp, token, MAXTOKEN);
        } while (type == COMMA);
        if (type != RIGHTBRACKET) {
            print_error("Expected \"}\" after list", token, type);
            goto skip;
        }
        type = get_token(fp, token, type);
    }
    if (type != STATUS) {
        print_error("Expected STATUS", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != CURRENT && type != DEPRECATED && type != OBSOLETE) {
        print_error("Bad STATUS value", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != DESCRIPTION) {
        print_error("Expected DESCRIPTION", token, type);
        goto skip;
    }
    type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    if (type != QUOTESTRING) {
        print_error("Bad DESCRIPTION", quoted_string_buffer, type);
        free_node(np);
        return NULL;
    }
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
			       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
        np->description = strdup(quoted_string_buffer);
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type == REFERENCE) {
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
        if (type != QUOTESTRING) {
            print_error("Bad REFERENCE", quoted_string_buffer, type);
            free_node(np);
            return NULL;
        }
        np->reference = strdup(quoted_string_buffer);
        type = get_token(fp, token, MAXTOKEN);
    }
    if (type != EQUALS)
        print_error("Expected \"::=\"", token, type);
  skip:
    while (type != EQUALS && type != ENDOFFILE)
        type = get_token(fp, token, MAXTOKEN);

    return merge_parse_objectid(np, fp, name);
} 

static struct varbind_list *
getVarbinds(FILE * fp, struct varbind_list **retp)
{
    int             type;
    char            token[MAXTOKEN];

    struct varbind_list *mylist = NULL;
    struct varbind_list **mypp = &mylist;

    free_varbinds(retp);

    type = get_token(fp, token, MAXTOKEN);

    if (type != LEFTBRACKET) {
        return NULL;
    }

    type = get_token(fp, token, MAXTOKEN);
    while (type != RIGHTBRACKET && type != ENDOFFILE) {
        if ((type == LABEL) || (type & SYNTAX_MASK)) {
            *mypp =
                (struct varbind_list *) calloc(1,
                                               sizeof(struct
                                                      varbind_list));
            if (*mypp) {
                (*mypp)->vblabel = strdup(token);
                mypp = &(*mypp)->next;
            }
        }
        type = get_token(fp, token, MAXTOKEN);
    }

    *retp = mylist;
    return mylist;
}

/*
 * Parses a TRAP-TYPE macro.
 * Returns 0 on error.
 */
static struct node *
parse_trapDefinition(FILE * fp, char *name)
{
    register int    type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    register struct node *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    while (type != EQUALS && type != ENDOFFILE) {
        switch (type) {
        case DESCRIPTION:
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            if (type != QUOTESTRING) {
                print_error("Bad DESCRIPTION", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
                np->description = strdup(quoted_string_buffer);
            }
            break;
        case REFERENCE:
            /* I'm not sure REFERENCEs are legal in smiv1 traps??? */
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            if (type != QUOTESTRING) {
                print_error("Bad REFERENCE", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            np->reference = strdup(quoted_string_buffer);
            break;
        case ENTERPRISE:
            type = get_token(fp, token, MAXTOKEN);
            if (type == LEFTBRACKET) {
                type = get_token(fp, token, MAXTOKEN);
                if (type != LABEL) {
                    print_error("Bad Trap Format", token, type);
                    free_node(np);
                    return NULL;
                }
                np->parent = strdup(token);
                /*
                 * Get right bracket 
                 */
                type = get_token(fp, token, MAXTOKEN);
            } else if (type == LABEL) {
                np->parent = strdup(token);
            } else {
                free_node(np);
                return NULL;
            }
            break;
        case VARIABLES:
            np->varbinds = getVarbinds(fp, &np->varbinds);
            if (!np->varbinds) {
                print_error("Bad VARIABLES list", token, type);
                free_node(np);
                return NULL;
            }
            break;
        default:
            /*
             * NOTHING 
             */
            break;
        }
        type = get_token(fp, token, MAXTOKEN);
    }
    type = get_token(fp, token, MAXTOKEN);

    np->label = strdup(name);

    if (type != NUMBER) {
        print_error("Expected a Number", token, type);
        free_node(np);
        return NULL;
    }
    np->subid = strtoul(token, NULL, 10);
    np->next = alloc_node(current_module);
    if (np->next == NULL) {
        free_node(np);
        return (NULL);
    }

    /* Catch the syntax error */
    if (np->parent == NULL) {
        free_node(np->next);
        free_node(np);
        gMibError = MODULE_SYNTAX_ERROR;
        return (NULL);
    }

    np->next->parent = np->parent;
    np->parent = (char *) malloc(strlen(np->parent) + 2);
    if (np->parent == NULL) {
        free_node(np->next);
        free_node(np);
        return (NULL);
    }
    strcpy(np->parent, np->next->parent);
    strcat(np->parent, "#");
    np->next->label = strdup(np->parent);
    return np;
} 

/*
 * Parses a NOTIFICATION-TYPE macro.
 * Returns 0 on error.
 */
static struct node *
parse_notificationDefinition(FILE * fp, char *name)
{
    register int    type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    register struct node *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    while (type != EQUALS && type != ENDOFFILE) {
        switch (type) {
        case DESCRIPTION:
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            if (type != QUOTESTRING) {
                print_error("Bad DESCRIPTION", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
				       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
                np->description = strdup(quoted_string_buffer);
            }
            break;
        case REFERENCE:
            type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            if (type != QUOTESTRING) {
                print_error("Bad REFERENCE", quoted_string_buffer, type);
                free_node(np);
                return NULL;
            }
            np->reference = strdup(quoted_string_buffer);
            break;
        case OBJECTS:
            np->varbinds = getVarbinds(fp, &np->varbinds);
            if (!np->varbinds) {
                print_error("Bad OBJECTS list", token, type);
                free_node(np);
                return NULL;
            }
            break;
        default:
            /*
             * NOTHING 
             */
            break;
        }
        type = get_token(fp, token, MAXTOKEN);
    }
    return merge_parse_objectid(np, fp, name);
} 

static int
compliance_lookup(const char *name, int modid)
{
    if (modid == -1) {
        struct objgroup *op =
            (struct objgroup *) malloc(sizeof(struct objgroup));
        if (!op)
            return 0;
        op->next = objgroups;
        op->name = strdup(name);
        op->line = mibLine;
        objgroups = op;
        return 1;
    } else
        return find_tree_node(name, modid) != NULL;
}
 
/*
 * Parses a compliance macro
 * Returns 0 on error.
 */
static int
eat_syntax(FILE * fp, char *token, int maxtoken)
{
    int             type, nexttype;
    struct node    *np = alloc_node(current_module);
    char            nexttoken[MAXTOKEN];

    if (!np)
	return 0;

    type = get_token(fp, token, maxtoken);
    nexttype = get_token(fp, nexttoken, MAXTOKEN);
    switch (type) {
    case INTEGER:
    case INTEGER32:
    case UINTEGER32:
    case UNSIGNED32:
    case COUNTER:
    case GAUGE:
    case BITSTRING:
    case LABEL:
        if (nexttype == LEFTBRACKET) {
            /*
             * if there is an enumeration list, parse it 
             */
            np->enums = parse_enumlist(fp, &np->enums);
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        } else if (nexttype == LEFTPAREN) {
            /*
             * if there is a range list, parse it 
             */
            np->ranges = parse_ranges(fp, &np->ranges);
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
        }
        break;
    case OCTETSTR:
    case KW_OPAQUE:
        /*
         * parse any SIZE specification 
         */
        if (nexttype == LEFTPAREN) {
            nexttype = get_token(fp, nexttoken, MAXTOKEN);
            if (nexttype == SIZE) {
                nexttype = get_token(fp, nexttoken, MAXTOKEN);
                if (nexttype == LEFTPAREN) {
                    np->ranges = parse_ranges(fp, &np->ranges);
                    nexttype = get_token(fp, nexttoken, MAXTOKEN);      /* ) */
                    if (nexttype == RIGHTPAREN) {
                        nexttype = get_token(fp, nexttoken, MAXTOKEN);
                        break;
                    }
                }
            }
            print_error("Bad SIZE syntax", token, type);
            free_node(np);
            return nexttype;
        }
        break;
    case OBJID:
    case NETADDR:
    case IPADDR:
    case TIMETICKS:
    case NUL:
    case NSAPADDRESS:
    case COUNTER64:
        break;
    default:
        print_error("Bad syntax", token, type);
        free_node(np);
        return nexttype;
    }
    free_node(np);
    return nexttype;
}

static struct node *
parse_compliance(FILE * fp, char *name)
{
    int             type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    struct node    *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    if (type != STATUS) {
        print_error("Expected STATUS", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != CURRENT && type != DEPRECATED && type != OBSOLETE) {
        print_error("Bad STATUS", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != DESCRIPTION) {
        print_error("Expected DESCRIPTION", token, type);
        goto skip;
    }
    type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    if (type != QUOTESTRING) {
        print_error("Bad DESCRIPTION", quoted_string_buffer, type);
        goto skip;
    }
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
			       NETSNMP_DS_LIB_SAVE_MIB_DESCRS))
        np->description = strdup(quoted_string_buffer);
    type = get_token(fp, token, MAXTOKEN);
    if (type == REFERENCE) {
        type = get_token(fp, quoted_string_buffer, MAXTOKEN);
        if (type != QUOTESTRING) {
            print_error("Bad REFERENCE", quoted_string_buffer, type);
            goto skip;
        }
        np->reference = strdup(quoted_string_buffer);
        type = get_token(fp, token, MAXTOKEN);
    }
    if (type != MODULE) {
        print_error("Expected MODULE", token, type);
        goto skip;
    }
    while (type == MODULE) {
        int             modid = -1;
        char            modname[MAXTOKEN];
        type = get_token(fp, token, MAXTOKEN);
        if (type == LABEL
            && strcmp(token, module_name(current_module, modname))) {
            modid = read_module_internal(token);
            if (modid != MODULE_LOADED_OK
                && modid != MODULE_ALREADY_LOADED) {
                print_error("Unknown module", token, type);
                goto skip;
            }
            modid = which_module(token);
            type = get_token(fp, token, MAXTOKEN);
        }
        if (type == MANDATORYGROUPS) {
            type = get_token(fp, token, MAXTOKEN);
            if (type != LEFTBRACKET) {
                print_error("Expected \"{\"", token, type);
                goto skip;
            }
            do {
                type = get_token(fp, token, MAXTOKEN);
                if (type != LABEL) {
                    print_error("Bad group name", token, type);
                    goto skip;
                }
                if (!compliance_lookup(token, modid))
                    print_error("Unknown group", token, type);
                type = get_token(fp, token, MAXTOKEN);
            } while (type == COMMA);
            if (type != RIGHTBRACKET) {
                print_error("Expected \"}\"", token, type);
                goto skip;
            }
            type = get_token(fp, token, MAXTOKEN);
        }
        while (type == GROUP || type == OBJECT) {
            if (type == GROUP) {
                type = get_token(fp, token, MAXTOKEN);
                if (type != LABEL) {
                    print_error("Bad group name", token, type);
                    goto skip;
                }
                if (!compliance_lookup(token, modid))
                    print_error("Unknown group", token, type);
                type = get_token(fp, token, MAXTOKEN);
            } else {
                type = get_token(fp, token, MAXTOKEN);
                if (type != LABEL) {
                    print_error("Bad object name", token, type);
                    goto skip;
                }
                if (!compliance_lookup(token, modid))
                    print_error("Unknown group", token, type);
                type = get_token(fp, token, MAXTOKEN);
                if (type == SYNTAX)
                    type = eat_syntax(fp, token, MAXTOKEN);
                if (type == WRSYNTAX)
                    type = eat_syntax(fp, token, MAXTOKEN);
                if (type == MINACCESS) {
                    type = get_token(fp, token, MAXTOKEN);
                    if (type != NOACCESS && type != ACCNOTIFY
                        && type != READONLY && type != WRITEONLY
                        && type != READCREATE && type != READWRITE) {
                        print_error("Bad MIN-ACCESS spec", token, type);
                        goto skip;
                    }
                    type = get_token(fp, token, MAXTOKEN);
                }
            }
            if (type != DESCRIPTION) {
                print_error("Expected DESCRIPTION", token, type);
                goto skip;
            }
            type = get_token(fp, token, MAXTOKEN);
            if (type != QUOTESTRING) {
                print_error("Bad DESCRIPTION", token, type);
                goto skip;
            }
            type = get_token(fp, token, MAXTOKEN);
        }
    }
  skip:
    while (type != EQUALS && type != ENDOFFILE)
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);

    return merge_parse_objectid(np, fp, name);
}


/*
 * Parses a capabilities macro
 * Returns 0 on error.
 */
static struct node *
parse_capabilities(FILE * fp, char *name)
{
    int             type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    struct node    *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    if (type != PRODREL) {
        print_error("Expected PRODUCT-RELEASE", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != QUOTESTRING) {
        print_error("Expected STRING after PRODUCT-RELEASE", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != STATUS) {
        print_error("Expected STATUS", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != CURRENT && type != OBSOLETE) {
        print_error("STATUS should be current or obsolete", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != DESCRIPTION) {
        print_error("Expected DESCRIPTION", token, type);
        goto skip;
    }
    type = get_token(fp, quoted_string_buffer, MAXTOKEN);
    if (type != QUOTESTRING) {
        print_error("Bad DESCRIPTION", quoted_string_buffer, type);
        goto skip;
    }
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
			       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
        np->description = strdup(quoted_string_buffer);
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type == REFERENCE) {
        type = get_token(fp, quoted_string_buffer, MAXTOKEN);
        if (type != QUOTESTRING) {
            print_error("Bad REFERENCE", quoted_string_buffer, type);
            goto skip;
        }
        np->reference = strdup(quoted_string_buffer);
        type = get_token(fp, token, type);
    }
    while (type == SUPPORTS) {
        int             modid;
        struct tree    *tp;

        type = get_token(fp, token, MAXTOKEN);
        if (type != LABEL) {
            print_error("Bad module name", token, type);
            goto skip;
        }
        modid = read_module_internal(token);
        if (modid != MODULE_LOADED_OK && modid != MODULE_ALREADY_LOADED) {
            print_error("Module not found", token, type);
            goto skip;
        }
        modid = which_module(token);
        type = get_token(fp, token, MAXTOKEN);
        if (type != INCLUDES) {
            print_error("Expected INCLUDES", token, type);
            goto skip;
        }
        type = get_token(fp, token, MAXTOKEN);
        if (type != LEFTBRACKET) {
            print_error("Expected \"{\"", token, type);
            goto skip;
        }
        do {
            type = get_token(fp, token, MAXTOKEN);
            if (type != LABEL) {
                print_error("Expected group name", token, type);
                goto skip;
            }
            tp = find_tree_node(token, modid);
            if (!tp)
                print_error("Group not found in module", token, type);
            type = get_token(fp, token, MAXTOKEN);
        } while (type == COMMA);
        if (type != RIGHTBRACKET) {
            print_error("Expected \"}\" after group list", token, type);
            goto skip;
        }
        type = get_token(fp, token, MAXTOKEN);
        while (type == VARIATION) {
            type = get_token(fp, token, MAXTOKEN);
            if (type != LABEL) {
                print_error("Bad object name", token, type);
                goto skip;
            }
            tp = find_tree_node(token, modid);
            if (!tp)
                print_error("Object not found in module", token, type);
            type = get_token(fp, token, MAXTOKEN);
            if (type == SYNTAX) {
                type = eat_syntax(fp, token, MAXTOKEN);
            }
            if (type == WRSYNTAX) {
                type = eat_syntax(fp, token, MAXTOKEN);
            }
            if (type == ACCESS) {
                type = get_token(fp, token, MAXTOKEN);
                if (type != ACCNOTIFY && type != READONLY
                    && type != READWRITE && type != READCREATE
                    && type != WRITEONLY && type != NOTIMPL) {
                    print_error("Bad ACCESS", token, type);
                    goto skip;
                }
                type = get_token(fp, token, MAXTOKEN);
            }
            if (type == CREATEREQ) {
                type = get_token(fp, token, MAXTOKEN);
                if (type != LEFTBRACKET) {
                    print_error("Expected \"{\"", token, type);
                    goto skip;
                }
                do {
                    type = get_token(fp, token, MAXTOKEN);
                    if (type != LABEL) {
                        print_error("Bad object name in list", token,
                                    type);
                        goto skip;
                    }
                    type = get_token(fp, token, MAXTOKEN);
                } while (type == COMMA);
                if (type != RIGHTBRACKET) {
                    print_error("Expected \"}\" after list", token, type);
                    goto skip;
                }
                type = get_token(fp, token, MAXTOKEN);
            }
            if (type == DEFVAL) {
                int             level = 1;
                type = get_token(fp, token, MAXTOKEN);
                if (type != LEFTBRACKET) {
                    print_error("Expected \"{\" after DEFVAL", token,
                                type);
                    goto skip;
                }
                do {
                    type = get_token(fp, token, MAXTOKEN);
                    if (type == LEFTBRACKET)
                        level++;
                    else if (type == RIGHTBRACKET)
                        level--;
                } while (type != RIGHTBRACKET && type != ENDOFFILE
                         && level != 0);
                if (type != RIGHTBRACKET) {
                    print_error("Missing \"}\" after DEFVAL", token, type);
                    goto skip;
                }
                type = get_token(fp, token, MAXTOKEN);
            }
            if (type != DESCRIPTION) {
                print_error("Expected DESCRIPTION", token, type);
                goto skip;
            }
            type = get_token(fp, quoted_string_buffer, MAXTOKEN);
            if (type != QUOTESTRING) {
                print_error("Bad DESCRIPTION", quoted_string_buffer, type);
                goto skip;
            }
            type = get_token(fp, token, MAXTOKEN);
        }
    }
    if (type != EQUALS)
        print_error("Expected \"::=\"", token, type);
  skip:
    while (type != EQUALS && type != ENDOFFILE) {
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    }
    return merge_parse_objectid(np, fp, name);
} 

/*
 * Parses a module identity macro
 * Returns 0 on error.
 */
static void
check_utc(const char *utc)
{
    int             len, year, month, day, hour, minute;

    len = strlen(utc);
    if (utc[len - 1] != 'Z' && utc[len - 1] != 'z') {
        print_error("Timestamp should end with Z", utc, QUOTESTRING);
        return;
    }
    if (len == 11) {
        len =
            sscanf(utc, "%2d%2d%2d%2d%2dZ", &year, &month, &day, &hour,
                   &minute);
        year += 1900;
    } else if (len == 13)
        len =
            sscanf(utc, "%4d%2d%2d%2d%2dZ", &year, &month, &day, &hour,
                   &minute);
    else {
        print_error("Bad timestamp format (11 or 13 characters)",
                    utc, QUOTESTRING);
        return;
    }
    if (len != 5) {
        print_error("Bad timestamp format", utc, QUOTESTRING);
        return;
    }
    if (month < 1 || month > 12)
        print_error("Bad month in timestamp", utc, QUOTESTRING);
    if (day < 1 || day > 31)
        print_error("Bad day in timestamp", utc, QUOTESTRING);
    if (hour < 0 || hour > 23)
        print_error("Bad hour in timestamp", utc, QUOTESTRING);
    if (minute < 0 || minute > 59)
        print_error("Bad minute in timestamp", utc, QUOTESTRING);
}

static struct node *
parse_moduleIdentity(FILE * fp, char *name)
{
    register int    type;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    register struct node *np;

    np = alloc_node(current_module);
    if (np == NULL)
        return (NULL);
    type = get_token(fp, token, MAXTOKEN);
    if (type != LASTUPDATED) {
        print_error("Expected LAST-UPDATED", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != QUOTESTRING) {
        print_error("Need STRING for LAST-UPDATED", token, type);
        goto skip;
    }
    check_utc(token);
    type = get_token(fp, token, MAXTOKEN);
    if (type != ORGANIZATION) {
        print_error("Expected ORGANIZATION", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != QUOTESTRING) {
        print_error("Bad ORGANIZATION", token, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != CONTACTINFO) {
        print_error("Expected CONTACT-INFO", token, type);
        goto skip;
    }
    type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    if (type != QUOTESTRING) {
        print_error("Bad CONTACT-INFO", quoted_string_buffer, type);
        goto skip;
    }
    type = get_token(fp, token, MAXTOKEN);
    if (type != DESCRIPTION) {
        print_error("Expected DESCRIPTION", token, type);
        goto skip;
    }
    type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    if (type != QUOTESTRING) {
        print_error("Bad DESCRIPTION", quoted_string_buffer, type);
        goto skip;
    }
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
			       NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
        np->description = strdup(quoted_string_buffer);
    }
    type = get_token(fp, token, MAXTOKEN);
    while (type == REVISION) {
        type = get_token(fp, token, MAXTOKEN);
        if (type != QUOTESTRING) {
            print_error("Bad REVISION", token, type);
            goto skip;
        }
        check_utc(token);
        type = get_token(fp, token, MAXTOKEN);
        if (type != DESCRIPTION) {
            print_error("Expected DESCRIPTION", token, type);
            goto skip;
        }
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
        if (type != QUOTESTRING) {
            print_error("Bad DESCRIPTION", quoted_string_buffer, type);
            goto skip;
        }
        type = get_token(fp, token, MAXTOKEN);
    }
    if (type != EQUALS)
        print_error("Expected \"::=\"", token, type);
  skip:
    while (type != EQUALS && type != ENDOFFILE) {
        type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
    }
    return merge_parse_objectid(np, fp, name);
} 

/*
 * Parses an asn type.  Structures are ignored by this parser.
 * Returns NULL on error.
 */
static struct node *
parse_asntype(FILE * fp, char *name, int *ntype, char *ntoken)
{
    int             type, i;
    char            token[MAXTOKEN];
    char            quoted_string_buffer[MAXQUOTESTR];
    char           *hint = NULL;
    char           *descr = NULL;
    struct tc      *tcp;
    int             level;

    type = get_token(fp, token, MAXTOKEN);
    if (type == SEQUENCE || type == CHOICE) {
        level = 0;
        while ((type = get_token(fp, token, MAXTOKEN)) != ENDOFFILE) {
            if (type == LEFTBRACKET) {
                level++;
            } else if (type == RIGHTBRACKET && --level == 0) {
                *ntype = get_token(fp, ntoken, MAXTOKEN);
                return NULL;
            }
        }
        print_error("Expected \"}\"", token, type);
        return NULL;
    } else if (type == LEFTBRACKET) {
        struct node    *np;
        int             ch_next = '{';
        ungetc(ch_next, fp);
        np = parse_objectid(fp, name);
        if (np != NULL) {
            *ntype = get_token(fp, ntoken, MAXTOKEN);
            return np;
        }
        return NULL;
    } else if (type == LEFTSQBRACK) {
        int             size = 0;
        do {
            type = get_token(fp, token, MAXTOKEN);
        } while (type != ENDOFFILE && type != RIGHTSQBRACK);
        if (type != RIGHTSQBRACK) {
            print_error("Expected \"]\"", token, type);
            return NULL;
        }
        type = get_token(fp, token, MAXTOKEN);
        if (type == IMPLICIT)
            type = get_token(fp, token, MAXTOKEN);
        *ntype = get_token(fp, ntoken, MAXTOKEN);
        if (*ntype == LEFTPAREN) {
            switch (type) {
            case OCTETSTR:
                *ntype = get_token(fp, ntoken, MAXTOKEN);
                if (*ntype != SIZE) {
                    print_error("Expected SIZE", ntoken, *ntype);
                    return NULL;
                }
                size = 1;
                *ntype = get_token(fp, ntoken, MAXTOKEN);
                if (*ntype != LEFTPAREN) {
                    print_error("Expected \"(\" after SIZE", ntoken,
                                *ntype);
                    return NULL;
                }
                /*
                 * fall through 
                 */
            case INTEGER:
                *ntype = get_token(fp, ntoken, MAXTOKEN);
                do {
                    if (*ntype != NUMBER)
                        print_error("Expected NUMBER", ntoken, *ntype);
                    *ntype = get_token(fp, ntoken, MAXTOKEN);
                    if (*ntype == RANGE) {
                        *ntype = get_token(fp, ntoken, MAXTOKEN);
                        if (*ntype != NUMBER)
                            print_error("Expected NUMBER", ntoken, *ntype);
                        *ntype = get_token(fp, ntoken, MAXTOKEN);
                    }
                } while (*ntype == BAR);
                if (*ntype != RIGHTPAREN) {
                    print_error("Expected \")\"", ntoken, *ntype);
                    return NULL;
                }
                *ntype = get_token(fp, ntoken, MAXTOKEN);
                if (size) {
                    if (*ntype != RIGHTPAREN) {
                        print_error("Expected \")\" to terminate SIZE",
                                    ntoken, *ntype);
                        return NULL;
                    }
                    *ntype = get_token(fp, ntoken, MAXTOKEN);
                }
            }
        }
        return NULL;
    } else {
        if (type == CONVENTION) {
            while (type != SYNTAX && type != ENDOFFILE) {
                if (type == DISPLAYHINT) {
                    type = get_token(fp, token, MAXTOKEN);
                    if (type != QUOTESTRING)
                        print_error("DISPLAY-HINT must be string", token,
                                    type);
                    else
                        hint = strdup(token);
                } else if (type == DESCRIPTION &&
                           netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, 
                                                  NETSNMP_DS_LIB_SAVE_MIB_DESCRS)) {
                    type = get_token(fp, quoted_string_buffer, MAXQUOTESTR);
                    if (type != QUOTESTRING)
                        print_error("DESCRIPTION must be string", token,
                                    type);
                    else
                        descr = strdup(quoted_string_buffer);
                } else
                    type =
                        get_token(fp, quoted_string_buffer, MAXQUOTESTR);
            }
            type = get_token(fp, token, MAXTOKEN);
            if (type == OBJECT) {
                type = get_token(fp, token, MAXTOKEN);
                if (type != IDENTIFIER) {
                    print_error("Expected IDENTIFIER", token, type);
                    SNMP_FREE(hint);
                    return NULL;
                }
                type = OBJID;
            }
        } else if (type == OBJECT) {
            type = get_token(fp, token, MAXTOKEN);
            if (type != IDENTIFIER) {
                print_error("Expected IDENTIFIER", token, type);
                return NULL;
            }
            type = OBJID;
        }

        if (type == LABEL) {
            type = get_tc(token, current_module, NULL, NULL, NULL, NULL);
        }

        /*
         * textual convention 
         */
        for (i = 0; i < MAXTC; i++) {
            if (tclist[i].type == 0)
                break;
        }

        if (i == MAXTC) {
            print_error("Too many textual conventions", token, type);
            SNMP_FREE(hint);
            return NULL;
        }
        if (!(type & SYNTAX_MASK)) {
            print_error("Textual convention doesn't map to real type",
                        token, type);
            SNMP_FREE(hint);
            return NULL;
        }
        tcp = &tclist[i];
        tcp->modid = current_module;
        tcp->descriptor = strdup(name);
        tcp->hint = hint;
        tcp->description = descr;
        tcp->type = type;
        *ntype = get_token(fp, ntoken, MAXTOKEN);
        if (*ntype == LEFTPAREN) {
            tcp->ranges = parse_ranges(fp, &tcp->ranges);
            *ntype = get_token(fp, ntoken, MAXTOKEN);
        } else if (*ntype == LEFTBRACKET) {
            /*
             * if there is an enumeration list, parse it 
             */
            tcp->enums = parse_enumlist(fp, &tcp->enums);
            *ntype = get_token(fp, ntoken, MAXTOKEN);
        }
        return NULL;
    }
} 

/*
 * Parses a mib file and returns a linked list of nodes found in the file.
 * Returns NULL on error.
 */
//static struct node* parse(FILE * fp, struct node *root) {
node* parse(FILE * fp, struct node *root) {
#ifdef TEST
    extern void     xmalloc_stats(FILE *);
#endif
    char            token[MAXTOKEN];
    char            name[MAXTOKEN+1];
    int             type = LABEL;
    int             lasttype = LABEL;

#define BETWEEN_MIBS          1
#define IN_MIB                2
    int             state = BETWEEN_MIBS;
    struct node    *np, *nnp;
    struct objgroup *oldgroups = NULL, *oldobjects = NULL, *oldnotifs =
        NULL;

//    DEBUGMSGTL(("parse-file", "Parsing file:  %s...\n", File));

    if (last_err_module)
        free(last_err_module);
    last_err_module = NULL;

    np = root;
    if (np != NULL) {
        /*
         * now find end of chain 
         */
        while (np->next)
            np = np->next;
    }

    while (type != ENDOFFILE) {
        if (lasttype == CONTINUE)
            lasttype = type;
        else
            type = lasttype = get_token(fp, token, MAXTOKEN);

        switch (type) {
        case END:
            if (state != IN_MIB) {
                print_error("Error, END before start of MIB", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            } else {
                struct module  *mp;
#ifdef TEST
                printf("\nNodes for Module %s:\n", name);
                print_nodes(stdout, root);
#endif
                for (mp = module_head; mp; mp = mp->next)
                    if (mp->modid == current_module)
                        break;
                scan_objlist(root, mp, objgroups, "Undefined OBJECT-GROUP");
                scan_objlist(root, mp, objects, "Undefined OBJECT");
                scan_objlist(root, mp, notifs, "Undefined NOTIFICATION");
                objgroups = oldgroups;
                objects = oldobjects;
                notifs = oldnotifs;
                do_linkup(mp, root);
                np = root = NULL;
            }
            state = BETWEEN_MIBS;
#ifdef TEST
            if (netsnmp_ds_get_int(NETSNMP_DS_LIBRARY_ID, 
				   NETSNMP_DS_LIB_MIB_WARNINGS)) {
                /* xmalloc_stats(stderr); */
	    }
#endif
            continue;
        case IMPORTS:
            parse_imports(fp);
            continue;
        case EXPORTS:
            while (type != SEMI && type != ENDOFFILE)
                type = get_token(fp, token, MAXTOKEN);
            continue;
        case LABEL:
        case INTEGER:
        case INTEGER32:
        case UINTEGER32:
        case UNSIGNED32:
        case COUNTER:
        case COUNTER64:
        case GAUGE:
        case IPADDR:
        case NETADDR:
        case NSAPADDRESS:
        case OBJSYNTAX:
        case APPSYNTAX:
        case SIMPLESYNTAX:
        case OBJNAME:
        case NOTIFNAME:
        case KW_OPAQUE:
        case TIMETICKS:
            break;
        case ENDOFFILE:
            continue;
        default:
//            strlcpy(name, token, sizeof(name));
            strcpy(name, token);
            type = get_token(fp, token, MAXTOKEN);
            nnp = NULL;
            if (type == MACRO) {
                nnp = parse_macro(fp, name);
                if (nnp == NULL) {
                    print_error("Bad parse of MACRO", NULL, type);
                    gMibError = MODULE_SYNTAX_ERROR;
                    /*
                     * return NULL;
                     */
                }
                free_node(nnp); /* IGNORE */
                nnp = NULL;
            } else
                print_error(name, "is a reserved word", lasttype);
            continue;           /* see if we can parse the rest of the file */
        }
//        strlcpy(name, token, sizeof(name));
        strcpy(name, token);
        type = get_token(fp, token, MAXTOKEN);
        nnp = NULL;

        /*
         * Handle obsolete method to assign an object identifier to a
         * module
         */
        if (lasttype == LABEL && type == LEFTBRACKET) {
            while (type != RIGHTBRACKET && type != ENDOFFILE)
                type = get_token(fp, token, MAXTOKEN);
            if (type == ENDOFFILE) {
                print_error("Expected \"}\"", token, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            type = get_token(fp, token, MAXTOKEN);
        }

        switch (type) {
        case DEFINITIONS:
            if (state != BETWEEN_MIBS) {
                print_error("Error, nested MIBS", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            state = IN_MIB;
            current_module = which_module(name);
            oldgroups = objgroups;
            objgroups = NULL;
            oldobjects = objects;
            objects = NULL;
            oldnotifs = notifs;
            notifs = NULL;
            if (current_module == -1) {
                new_module(name, File);
                current_module = which_module(name);
            }
//            DEBUGMSGTL(("parse-mibs", "Parsing MIB: %d %s\n", current_module, name));
            while ((type = get_token(fp, token, MAXTOKEN)) != ENDOFFILE)
                if (type == BEGIN)
                    break;
            break;
        case OBJTYPE:
            nnp = parse_objecttype(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of OBJECT-TYPE", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case OBJGROUP:
            nnp = parse_objectgroup(fp, name, OBJECTS, &objects);
            if (nnp == NULL) {
                print_error("Bad parse of OBJECT-GROUP", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case NOTIFGROUP:
            nnp = parse_objectgroup(fp, name, NOTIFICATIONS, &notifs);
            if (nnp == NULL) {
                print_error("Bad parse of NOTIFICATION-GROUP", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case TRAPTYPE:
            nnp = parse_trapDefinition(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of TRAP-TYPE", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case NOTIFTYPE:
            nnp = parse_notificationDefinition(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of NOTIFICATION-TYPE", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case COMPLIANCE:
            nnp = parse_compliance(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of MODULE-COMPLIANCE", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case AGENTCAP:
            nnp = parse_capabilities(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of AGENT-CAPABILITIES", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case MACRO:
            nnp = parse_macro(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of MACRO", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                /*
                 * return NULL;
                 */
            }
            free_node(nnp);     /* IGNORE */
            nnp = NULL;
            break;
        case MODULEIDENTITY:
            nnp = parse_moduleIdentity(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of MODULE-IDENTITY", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case OBJIDENTITY:
            nnp = parse_objectgroup(fp, name, OBJECTS, &objects);
            if (nnp == NULL) {
                print_error("Bad parse of OBJECT-IDENTITY", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case OBJECT:
            type = get_token(fp, token, MAXTOKEN);
            if (type != IDENTIFIER) {
                print_error("Expected IDENTIFIER", token, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            type = get_token(fp, token, MAXTOKEN);
            if (type != EQUALS) {
                print_error("Expected \"::=\"", token, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            nnp = parse_objectid(fp, name);
            if (nnp == NULL) {
                print_error("Bad parse of OBJECT IDENTIFIER", NULL, type);
                gMibError = MODULE_SYNTAX_ERROR;
                return NULL;
            }
            break;
        case EQUALS:
            nnp = parse_asntype(fp, name, &type, token);
            lasttype = CONTINUE;
            break;
        case ENDOFFILE:
            break;
        default:
            print_error("Bad operator", token, type);
            gMibError = MODULE_SYNTAX_ERROR;
            return NULL;
        }
        if (nnp) {
            if (np)
                np->next = nnp;
            else
                np = root = nnp;
            while (np->next)
                np = np->next;
            if (np->type == TYPE_OTHER)
                np->type = type;
        }
    }
//    DEBUGMSGTL(("parse-file", "End of file (%s)\n", File));
    return root;
} 



struct tree* netsnmp_read_module(const char *name) {
    int status = 0;
    status = read_module_internal(name);

    if (status == MODULE_NOT_FOUND) {
        if (!read_module_replacements(name))
            print_module_not_found(name);
    } else if (status == MODULE_SYNTAX_ERROR) {
        gMibError = 0;
        gLoop = 1;

        strncat(gMibNames, " ", sizeof(gMibNames) - strlen(gMibNames) - 1);
        strncat(gMibNames, name, sizeof(gMibNames) - strlen(gMibNames) - 1);
    }

    return tree_head;
}
 

int get_module_node(const char *fname, const char *module, oid * objid, size_t * objidlen) {
    int             modid, rc = 0;
    struct tree    *tp;
    char           *name, *cp;

    if (!strcmp(module, "ANY"))
        modid = -1;
    else {
        netsnmp_read_module(module);
        modid = which_module(module);
        if (modid == -1)
            return 0;
    }

    /*
     * Isolate the first component of the name ... 
     */
    name = strdup(fname);
    cp = strchr(name, '.');
    if (cp != NULL) {
        *cp = '\0';
        cp++;
    }
    /*
     * ... and locate it in the tree. 
     */
    tp = find_tree_node(name, modid);
    if (tp) {
        size_t          maxlen = *objidlen;

        /*
         * Set the first element of the object ID 
         */
        if (node_to_oid(tp, objid, objidlen)) {
            rc = 1;

            /*
             * If the name requested was more than one element,
             * tag on the rest of the components 
             */
            if (cp != NULL)
                rc = _add_strings_to_oid(tp, cp, objid, objidlen, maxlen);
        }
    }

    SNMP_FREE(name);
    return (rc);
} 
#endif /* NETSNMP_DISABLE_MIB_LOADING */ 

/**
 * Reads an object identifier from an input string into internal OID form.
 * 
 * When called, out_len must hold the maximum length of the output array.
 *
 * @param input     the input string.
 * @param output    the oid wirte.
 * @param out_len   number of subid's in output.
 * 
 * @return 1 if successful.
 * 
 * If an error occurs, this function returns 0 and MAY set snmp_errno.
 * snmp_errno is NOT set if SET_SNMP_ERROR evaluates to nothing.
 * This can make multi-threaded use a tiny bit more robust.
 */
int
read_objid(const char *input, oid * output, size_t * out_len) {                               /* number of subid's in "output" */
#ifndef NETSNMP_DISABLE_MIB_LOADING
    struct tree    *root = tree_top;
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    char            buf[SPRINT_MAX_LEN];
    int             ret, max_out_len;
    char           *name, ch;
    const char     *cp;

    cp = input;
    while ((ch = *cp)) {
        if (('0' <= ch && ch <= '9')
            || ('a' <= ch && ch <= 'z')
            || ('A' <= ch && ch <= 'Z')
            || ch == '-')
            cp++;
        else
            break;
    }
#ifndef NETSNMP_DISABLE_MIB_LOADING
    if (ch == ':')
        return get_node(input, output, out_len);
#endif /* NETSNMP_DISABLE_MIB_LOADING */

    if (*input == '.')
        input++;
#ifndef NETSNMP_DISABLE_MIB_LOADING
    else if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_READ_UCD_STYLE_OID)) {
        /*
         * get past leading '.', append '.' to Prefix. 
         */
        if (*Prefix == '.')
//            strlcpy(buf, Prefix + 1, sizeof(buf));
            strcpy(buf, Prefix + 1);
        else
//            strlcpy(buf, Prefix, sizeof(buf));
            strcpy(buf, Prefix);
        //strlcat(buf, ".", sizeof(buf));
        //strlcat(buf, input, sizeof(buf));
        strcat(buf, ".");
        strcat(buf, input);
        input = buf;
    }
#endif /* NETSNMP_DISABLE_MIB_LOADING */

#ifndef NETSNMP_DISABLE_MIB_LOADING
    if ((root == NULL) && (tree_head != NULL)) {
        root = tree_head;
    }
    else if (root == NULL) {
        SET_SNMP_ERROR(SNMPERR_NOMIB);
        *out_len = 0;
        return 0;
    }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    name = strdup(input);
    max_out_len = *out_len;
    *out_len = 0;
#ifndef NETSNMP_DISABLE_MIB_LOADING
    if ((ret = _add_strings_to_oid(root, name, output, out_len, max_out_len)) <= 0)
#else
    if ((ret =
         _add_strings_to_oid(NULL, name, output, out_len,
                             max_out_len)) <= 0)
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    {
        if (ret == 0)
            ret = SNMPERR_UNKNOWN_OBJID;
        SET_SNMP_ERROR(ret);
        SNMP_FREE(name);
        return 0;
    }
    SNMP_FREE(name);

    return 1;
} 

/*
 * Find the tree node that best matches the pattern string.
 * Use the "reported" flag such that only one match
 * is attempted for every node.
 *
 * Warning! This function may recurse.
 *
 * Caller _must_ invoke clear_tree_flags before first call
 * to this function.  This function may be called multiple times
 * to ensure that the entire tree is traversed.
 */
#define MAX_BAD 0xffffff 


/*
 * only glibc2 has this.
 */
char           *
strcasestr(const char *haystack, const char *needle)
{
    const char     *cp1 = haystack, *cp2 = needle;
    const char     *cx;
    int             tstch1, tstch2;

    /*
     * printf("looking for '%s' in '%s'\n", needle, haystack); 
     */
    if (cp1 && cp2 && *cp1 && *cp2)
        for (cp1 = haystack, cp2 = needle; *cp1;) {
            cx = cp1;
            cp2 = needle;
            do {
                /*
                 * printf("T'%c' ", *cp1); 
                 */
                if (!*cp2) {    /* found the needle */
                    /*
                     * printf("\nfound '%s' in '%s'\n", needle, cx); 
                     */
                    return NETSNMP_REMOVE_CONST(char *, cx);
                }
                if (!*cp1)
                    break;

                tstch1 = toupper(*cp1);
                tstch2 = toupper(*cp2);
                if (tstch1 != tstch2)
                    break;
                /*
                 * printf("M'%c' ", *cp1); 
                 */
                cp1++;
                cp2++;
            }
            while (1);
            if (*cp1)
                cp1++;
        }
    /*
     * printf("\n"); 
     */
    if (cp1 && *cp1)
        return NETSNMP_REMOVE_CONST(char *, cp1);

    return NULL;
}

static          u_int
compute_match(const char *search_base, const char *key)
{
#if defined(HAVE_REGEX_H) && defined(HAVE_REGCOMP)
    int             rc;
    regex_t         parsetree;
    regmatch_t      pmatch;
    rc = regcomp(&parsetree, key, REG_ICASE | REG_EXTENDED);
    if (rc == 0)
        rc = regexec(&parsetree, search_base, 1, &pmatch, 0);
    regfree(&parsetree);
    if (rc == 0) {
        /*
         * found 
         */
        return pmatch.rm_so;
    }
#else                           /* use our own wildcard matcher */
    /*
     * first find the longest matching substring (ick) 
     */
    char           *first = NULL, *result = NULL, *entry;
    const char     *position;
    char           *newkey = strdup(key);
    char           *st;


    entry = strtok_r(newkey, "*", &st);
    position = search_base;
    while (entry) {
        result = strcasestr(position, entry);

        if (result == NULL) {
            free(newkey);
            return MAX_BAD;
        }

        if (first == NULL)
            first = result;

        position = result + strlen(entry);
        entry = strtok_r(NULL, "*", &st);
    }
    free(newkey);
    if (result)
        return (first - search_base);
#endif

    /*
     * not found 
     */
    return MAX_BAD;
}
 
/**
 * Retrieves the tree head.
 *
 * @return the tree head.
 */
struct tree* get_tree_head(void) {
    return (tree_head);
}


struct tree* find_best_tree_node(const char *pattrn, struct tree *tree_top, u_int * match) {
    struct tree    *tp, *best_so_far = NULL, *retptr;
    u_int           old_match = MAX_BAD, new_match = MAX_BAD;

    if (!pattrn || !*pattrn)
        return (NULL);

    if (!tree_top)
        tree_top = get_tree_head();

    for (tp = tree_top; tp; tp = tp->next_peer) {
        if (!tp->reported && tp->label)
            new_match = compute_match(tp->label, pattrn);
        tp->reported = 1;

        if (new_match < old_match) {
            best_so_far = tp;
            old_match = new_match;
        }
        if (new_match == 0)
            break;              /* this is the best result we can get */
        if (tp->child_list) {
            retptr =
                find_best_tree_node(pattrn, tp->child_list, &new_match);
            if (new_match < old_match) {
                best_so_far = retptr;
                old_match = new_match;
            }
            if (new_match == 0)
                break;          /* this is the best result we can get */
        }
    }
    if (match)
        *match = old_match;
    return (best_so_far);
} 

/**
 * Given a string, parses an oid out of it (if possible).
 * It will try to parse it based on predetermined configuration if
 * present or by every method possible otherwise.
 * If a suffix has been registered using NETSNMP_DS_LIB_OIDSUFFIX, it
 * will be appended to the input string before processing.
 *
 * @param argv    The OID to string parse
 * @param root    An OID array where the results are stored.
 * @param rootlen The max length of the array going in and the data
 *                length coming out.
 *
 * @return        The root oid pointer if successful, or NULL otherwise.
 */
 
oid* snmp_parse_oid(const char *argv, oid * root, size_t * rootlen) {
    size_t          savlen = *rootlen;
    static size_t   tmpbuf_len = 0;
    static char    *tmpbuf;
    const char     *suffix, *prefix;

    suffix = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID,
                                   NETSNMP_DS_LIB_OIDSUFFIX);
    prefix = netsnmp_ds_get_string(NETSNMP_DS_LIBRARY_ID,
                                   NETSNMP_DS_LIB_OIDPREFIX);
    if ((suffix && suffix[0]) || (prefix && prefix[0])) {
        if (!suffix)
            suffix = "";
        if (!prefix)
            prefix = "";
        if ((strlen(suffix) + strlen(prefix) + strlen(argv) + 2) > tmpbuf_len) {
            tmpbuf_len = strlen(suffix) + strlen(argv) + strlen(prefix) + 2;
            tmpbuf = (char *)realloc(tmpbuf, tmpbuf_len);
        }
//        snprintf(tmpbuf, tmpbuf_len, "%s%s%s%s", prefix, argv, ((suffix[0] == '.' || suffix[0] == '\0') ? "" : "."), suffix);
        sprintf(tmpbuf, "%s%s%s%s", prefix, argv, ((suffix[0] == '.' || suffix[0] == '\0') ? "" : "."), suffix);
        argv = tmpbuf;
//        DEBUGMSGTL(("snmp_parse_oid","Parsing: %s\n",argv));
    }

#ifndef NETSNMP_DISABLE_MIB_LOADING
    if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_RANDOM_ACCESS)
        || strchr(argv, ':')) {
        if (get_node(argv, root, rootlen)) {
            return root;
        }
    } else if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_REGEX_ACCESS)) {
	clear_tree_flags(tree_head);
        if (get_wild_node(argv, root, rootlen)) {
            return root;
        }
    } else {
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        if (read_objid(argv, root, rootlen)) {
            return root;
        }
#ifndef NETSNMP_DISABLE_MIB_LOADING
        *rootlen = savlen;
        if (get_node(argv, root, rootlen)) {
            return root;
        }
        *rootlen = savlen;
//        DEBUGMSGTL(("parse_oid", "wildly parsing\n"));
	clear_tree_flags(tree_head);
        if (get_wild_node(argv, root, rootlen)) {
            return root;
        }
    }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    return NULL;
} 

struct tree* get_tree(const oid * objid, size_t objidlen, struct tree *subtree) {
    struct tree    *return_tree = NULL;

    for (; subtree; subtree = subtree->next_peer) {
        if (*objid == subtree->subid)
            goto found;
    }

    return NULL;

  found:
    while (subtree->next_peer && subtree->next_peer->subid == *objid)
	subtree = subtree->next_peer;
    if (objidlen > 1)
        return_tree =
            get_tree(objid + 1, objidlen - 1, subtree->child_list);
    if (return_tree != NULL)
        return return_tree;
    else
        return subtree;
}
 
/*
 * Add a variable with the requested name to the end of the list of
 * variables for this pdu.
 */
netsnmp_variable_list *
snmp_pdu_add_variable(netsnmp_pdu *pdu,
                      const oid * name,
                      size_t name_length,
                      u_char type, const void * value, size_t len)
{
    return snmp_varlist_add_variable(&pdu->variables, name, name_length,
                                     type, value, len);
}

/*
 * Frees the variable and any malloc'd data associated with it.
 */
void snmp_free_var_internals(netsnmp_variable_list * var) {
    if (!var)
        return;

    if (var->name != var->name_loc)
        SNMP_FREE(var->name);
    if (var->val.string != var->buf)
        SNMP_FREE(var->val.string);
    if (var->data) {
        if (var->dataFreeHook) {
            var->dataFreeHook(var->data);
            var->data = NULL;
        } else {
            SNMP_FREE(var->data);
        }
    }
} 

void snmp_free_var(netsnmp_variable_list * var) {
    snmp_free_var_internals(var);
    free((char *) var);
}
 
/*
 * Add object identifier name to SNMP variable.
 * If the name is large, additional memory is allocated.
 * Returns 0 if successful.
 */

int snmp_set_var_objid(netsnmp_variable_list * vp, const oid * objid, size_t name_length) {
    size_t          len = sizeof(oid) * name_length;

    if (vp->name != vp->name_loc && vp->name != NULL) {
        /*
         * Probably previously-allocated "big storage".  Better free it
         * else memory leaks possible.  
         */
        free(vp->name);
    }

    /*
     * use built-in storage for smaller values 
     */
    if (len <= sizeof(vp->name_loc)) {
        vp->name = vp->name_loc;
    } else {
        vp->name = (oid *) malloc(len);
        if (!vp->name)
            return 1;
    }
    if (objid)
        memmove(vp->name, objid, len);
    vp->name_length = name_length;
    return 0;
}
 
/*
 * Add some value to SNMP variable.
 * If the value is large, additional memory is allocated.
 * Returns 0 if successful.
 */

int
snmp_set_var_value(netsnmp_variable_list * vars,
                   const void * value, size_t len)
{
    int             largeval = 1;

    /*
     * xxx-rks: why the unconditional free? why not use existing
     * memory, if len < vars->val_len ?
     */
    if (vars->val.string && vars->val.string != vars->buf) {
        free(vars->val.string);
    }
    vars->val.string = NULL;
    vars->val_len = 0;

    if (value == NULL && len > 0) {
        snmp_log(LOG_ERR, "bad size for NULL value\n");
        return 1;
    }

    /*
     * use built-in storage for smaller values 
     */
    if (len <= sizeof(vars->buf)) {
        vars->val.string = (u_char *) vars->buf;
        largeval = 0;
    }

    if ((0 == len) || (NULL == value)) {
        vars->val.string[0] = 0;
        return 0;
    }

    vars->val_len = len;
    switch (vars->type) {
    case ASN_INTEGER:
    case ASN_UNSIGNED:
    case ASN_TIMETICKS:
    case ASN_COUNTER:
    case ASN_UINTEGER:
        if (vars->val_len == sizeof(int)) {
            if (ASN_INTEGER == vars->type) {
                const int      *val_int 
                    = (const int *) value;
                *(vars->val.integer) = (long) *val_int;
            } else {
                const u_int    *val_uint
                    = (const u_int *) value;
                *(vars->val.integer) = (unsigned long) *val_uint;
            }
        }
#if SIZEOF_LONG != SIZEOF_INT
        else if (vars->val_len == sizeof(long)){
            const u_long   *val_ulong
                = (const u_long *) value;
            *(vars->val.integer) = *val_ulong;
            if (*(vars->val.integer) > 0xffffffff) {
                snmp_log(LOG_ERR,"truncating integer value > 32 bits\n");
                *(vars->val.integer) &= 0xffffffff;
            }
        }
#endif
#if defined(SIZEOF_LONG_LONG) && (SIZEOF_LONG != SIZEOF_LONG_LONG)
#if !defined(SIZEOF_INTMAX_T) || (SIZEOF_LONG_LONG != SIZEOF_INTMAX_T)
        else if (vars->val_len == sizeof(long long)){
            const unsigned long long   *val_ullong
                = (const unsigned long long *) value;
            *(vars->val.integer) = (long) *val_ullong;
            if (*(vars->val.integer) > 0xffffffff) {
                snmp_log(LOG_ERR,"truncating integer value > 32 bits\n");
                *(vars->val.integer) &= 0xffffffff;
            }
        }
#endif
#endif
#if defined(SIZEOF_INTMAX_T) && (SIZEOF_LONG != SIZEOF_INTMAX_T)
        else if (vars->val_len == sizeof(intmax_t)){
            const uintmax_t *val_uintmax_t
                = (const uintmax_t *) value;
            *(vars->val.integer) = (long) *val_uintmax_t;
            if (*(vars->val.integer) > 0xffffffff) {
                snmp_log(LOG_ERR,"truncating integer value > 32 bits\n");
                *(vars->val.integer) &= 0xffffffff;
            }
        }
#endif
#if SIZEOF_SHORT != SIZEOF_INT
        else if (vars->val_len == sizeof(short)) {
            if (ASN_INTEGER == vars->type) {
                const short      *val_short 
                    = (const short *) value;
                *(vars->val.integer) = (long) *val_short;
            } else {
                const u_short    *val_ushort
                    = (const u_short *) value;
                *(vars->val.integer) = (unsigned long) *val_ushort;
            }
        }
#endif
        else if (vars->val_len == sizeof(char)) {
            if (ASN_INTEGER == vars->type) {
                const char      *val_char 
                    = (const char *) value;
                *(vars->val.integer) = (long) *val_char;
            } else {
                    const u_char    *val_uchar
                    = (const u_char *) value;
                *(vars->val.integer) = (unsigned long) *val_uchar;
            }
        }
        else {
            snmp_log(LOG_ERR,"bad size for integer-like type (%d)\n",
                     (int)vars->val_len);
            return (1);
        }
        vars->val_len = sizeof(long);
        break;

    case ASN_OBJECT_ID:
    case ASN_PRIV_IMPLIED_OBJECT_ID:
    case ASN_PRIV_INCL_RANGE:
    case ASN_PRIV_EXCL_RANGE:
        if (largeval) {
            vars->val.objid = (oid *) malloc(vars->val_len);
        }
        if (vars->val.objid == NULL) {
            snmp_log(LOG_ERR,"no storage for OID\n");
            return 1;
        }
        memmove(vars->val.objid, value, vars->val_len);
        break;

    case ASN_IPADDRESS: /* snmp_build_var_op treats IPADDR like a string */
        if (4 != vars->val_len) {
            netsnmp_assert("ipaddress length == 4");
        }
        /** FALL THROUGH */
    case ASN_PRIV_IMPLIED_OCTET_STR:
    case ASN_OCTET_STR:
    case ASN_BIT_STR:
    case ASN_OPAQUE:
    case ASN_NSAP:
        if (vars->val_len >= sizeof(vars->buf)) {
            vars->val.string = (u_char *) malloc(vars->val_len + 1);
        }
        if (vars->val.string == NULL) {
            snmp_log(LOG_ERR,"no storage for string\n");
            return 1;
        }
        memmove(vars->val.string, value, vars->val_len);
        /*
         * Make sure the string is zero-terminated; some bits of code make
         * this assumption.  Easier to do this here than fix all these wrong
         * assumptions.  
         */
        vars->val.string[vars->val_len] = '\0';
        break;

    case SNMP_NOSUCHOBJECT:
    case SNMP_NOSUCHINSTANCE:
    case SNMP_ENDOFMIBVIEW:
    case ASN_NULL:
        vars->val_len = 0;
        vars->val.string = NULL;
        break;

#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_U64:
    case ASN_OPAQUE_I64:
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
    case ASN_COUNTER64:
        if (largeval) {
            snmp_log(LOG_ERR,"bad size for counter 64 (%d)\n",
                     (int)vars->val_len);
            return (1);
        }
        vars->val_len = sizeof(struct counter64);
        memmove(vars->val.counter64, value, vars->val_len);
        break;

#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_FLOAT:
        if (largeval) {
            snmp_log(LOG_ERR,"bad size for opaque float (%d)\n",
                     (int)vars->val_len);
            return (1);
        }
        vars->val_len = sizeof(float);
        memmove(vars->val.floatVal, value, vars->val_len);
        break;

    case ASN_OPAQUE_DOUBLE:
        if (largeval) {
            snmp_log(LOG_ERR,"bad size for opaque double (%d)\n",
                     (int)vars->val_len);
            return (1);
        }
        vars->val_len = sizeof(double);
        memmove(vars->val.doubleVal, value, vars->val_len);
        break;

#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */

    default:
        snmp_log(LOG_ERR,"Internal error in type switching\n");
        snmp_set_detail("Internal error in type switching\n");
        return (1);
    }

    return 0;
} 

/*
 * Add a variable with the requested name to the end of the list of
 * variables for this pdu.
 */
netsnmp_variable_list *
snmp_varlist_add_variable(netsnmp_variable_list ** varlist,
                          const oid * name,
                          size_t name_length,
                          u_char type, const void * value, size_t len)
{
    netsnmp_variable_list *vars, *vtmp;
    int rc;

    if (varlist == NULL)
        return NULL;

    vars = SNMP_MALLOC_TYPEDEF(netsnmp_variable_list);
    if (vars == NULL)
        return NULL;

    vars->type = type;

    rc = snmp_set_var_value( vars, value, len );
    if (( 0 != rc ) ||
        (name != NULL && snmp_set_var_objid(vars, name, name_length))) {
        snmp_free_var(vars);
        return NULL;
    }

    /*
     * put only qualified variable onto varlist 
     */
    if (*varlist == NULL) {
        *varlist = vars;
    } else {
        for (vtmp = *varlist; vtmp->next_variable;
             vtmp = vtmp->next_variable);

        vtmp->next_variable = vars;
    }

    return vars;
} 


/*
 * Add a variable with the requested name to the end of the list of
 * variables for this pdu.
 * Returns:
 * may set these error types :
 * SNMPERR_RANGE - type, value, or length not found or out of range
 * SNMPERR_VALUE - value is not correct
 * SNMPERR_VAR_TYPE - type is not correct
 * SNMPERR_BAD_NAME - name is not found
 *
 * returns 0 if success, error if failure.
 */
int
snmp_add_var(netsnmp_pdu *pdu, const oid * name, size_t name_length, char type, const char *value) {
    char           *st;
    const char     *cp;
    char           *ecp, *vp;
    int             result = SNMPERR_SUCCESS;

#ifndef NETSNMP_DISABLE_MIB_LOADING
    int             check = !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_DONT_CHECK_RANGE);
    int             do_hint = !netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_NO_DISPLAY_HINT);
    u_char         *hintptr;
    struct tree    *tp;
#endif // NETSNMP_DISABLE_MIB_LOADING 

    u_char         *buf = NULL;
    const u_char   *buf_ptr = NULL;
    size_t          buf_len = 0, value_len = 0, tint;
    in_addr_t       atmp;
    long            ltmp;
    int             itmp;
    struct enum_list *ep;
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    double          dtmp;
    float           ftmp;
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
    struct counter64 c64tmp;

#ifndef NETSNMP_DISABLE_MIB_LOADING
    tp = get_tree(name, name_length, get_tree_head());
    if (!tp || !tp->type || tp->type > TYPE_SIMPLE_LAST) {
        check = 0;
    }
    if (!(tp && tp->hint))
	do_hint = 0;

    if (tp && type == '=') {
        /*
         * generic assignment - let the tree node decide value format 
         */
        switch (tp->type) {
        case TYPE_INTEGER:
        case TYPE_INTEGER32:
            type = 'i';
            break;
        case TYPE_GAUGE:
        case TYPE_UNSIGNED32:
            type = 'u';
            break;
        case TYPE_UINTEGER:
            type = '3';
            break;
        case TYPE_COUNTER:
            type = 'c';
            break;
        case TYPE_COUNTER64:
            type = 'C';
            break;
        case TYPE_TIMETICKS:
            type = 't';
            break;
        case TYPE_OCTETSTR:
            type = 's';
            break;
        case TYPE_BITSTRING:
            type = 'b';
            break;
        case TYPE_IPADDR:
            type = 'a';
            break;
        case TYPE_OBJID:
            type = 'o';
            break;
        }
    }
#endif /* NETSNMP_DISABLE_MIB_LOADING */

    switch (type) {
    case 'i':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_INTEGER
            && tp->type != TYPE_INTEGER32) {
            value = "INTEGER";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        if (!*value)
            goto fail;
        ltmp = strtol(value, &ecp, 10);
        if (*ecp) {
#ifndef NETSNMP_DISABLE_MIB_LOADING
            ep = tp ? tp->enums : NULL;
            while (ep) {
                if (strcmp(value, ep->label) == 0) {
                    ltmp = ep->value;
                    break;
                }
                ep = ep->next;
            }
            if (!ep) {
#endif /* NETSNMP_DISABLE_MIB_LOADING */
                result = SNMPERR_RANGE;   /* ?? or SNMPERR_VALUE; */
                snmp_set_detail(value);
                break;
#ifndef NETSNMP_DISABLE_MIB_LOADING
            }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        }

#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (!_check_range(tp, ltmp, &result, value))
            break;
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        snmp_pdu_add_variable(pdu, name, name_length, ASN_INTEGER, &ltmp, sizeof(ltmp));
        break;

    case 'u':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_GAUGE && tp->type != TYPE_UNSIGNED32) {
            value = "Unsigned32";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        ltmp = strtoul(value, &ecp, 10);
        if (*value && !*ecp)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_UNSIGNED,
                                  &ltmp, sizeof(ltmp));
        else
            goto fail;
        break;

    case '3':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_UINTEGER) {
            value = "UInteger32";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        ltmp = strtoul(value, &ecp, 10);
        if (*value && !*ecp)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_UINTEGER,
                                  &ltmp, sizeof(ltmp));
        else
            goto fail;
        break;

    case 'c':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_COUNTER) {
            value = "Counter32";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        ltmp = strtoul(value, &ecp, 10);
        if (*value && !*ecp)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_COUNTER,
                                  &ltmp, sizeof(ltmp));
        else
            goto fail;
        break;

    case 'C':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_COUNTER64) {
            value = "Counter64";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        if (read64(&c64tmp, value))
            snmp_pdu_add_variable(pdu, name, name_length, ASN_COUNTER64,
                                  &c64tmp, sizeof(c64tmp));
        else
            goto fail;
        break;

    case 't':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_TIMETICKS) {
            value = "Timeticks";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        ltmp = strtoul(value, &ecp, 10);
        if (*value && !*ecp)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_TIMETICKS,
                                  &ltmp, sizeof(long));
        else
            goto fail;
        break;

    case 'a':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_IPADDR) {
            value = "IpAddress";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        atmp = inet_addr(value);
        if (atmp != (in_addr_t) -1 || !strcmp(value, "255.255.255.255"))
            snmp_pdu_add_variable(pdu, name, name_length, ASN_IPADDRESS,
                                  &atmp, sizeof(atmp));
        else
            goto fail;
        break;

    case 'o':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_OBJID) {
            value = "OBJECT IDENTIFIER";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        if ((buf = (u_char *)malloc(sizeof(oid) * MAX_OID_LEN)) == NULL) {
            result = SNMPERR_MALLOC;
        } else {
            tint = MAX_OID_LEN;
            if (snmp_parse_oid(value, (oid *) buf, &tint)) {
                snmp_pdu_add_variable(pdu, name, name_length, ASN_OBJECT_ID, buf, sizeof(oid) * tint);
            } else {
                result = snmp_errno;    /*MTCRITICAL_RESOURCE */
            }
        }
        break;

    case 's':
    case 'x':
    case 'd':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && tp->type != TYPE_OCTETSTR && tp->type != TYPE_BITSTRING) {
            value = "OCTET STRING";
            result = SNMPERR_VALUE;
            goto type_error;
        }
				if ('s' == type && do_hint && !parse_octet_hint(tp->hint, value, &hintptr, &itmp)) {
            if (_check_range(tp, itmp, &result, "Value does not match DISPLAY-HINT")) {
               snmp_pdu_add_variable(pdu, name, name_length, ASN_OCTET_STR, hintptr, itmp);
            }
            SNMP_FREE(hintptr);
            hintptr = buf;
            break;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        if (type == 'd') {
            if (!snmp_decimal_to_binary
                (&buf, &buf_len, &value_len, 1, value)) {
                result = SNMPERR_VALUE;
                snmp_set_detail(value);
                break;
            }
            buf_ptr = buf;
        } else if (type == 'x') {
            if (!snmp_hex_to_binary(&buf, &buf_len, &value_len, 1, value)) {
                result = SNMPERR_VALUE;
                snmp_set_detail(value);
                break;
            }
            /* initialize itmp value so that range check below works */
            itmp = value_len;
            buf_ptr = buf;
        } else if (type == 's') {
            buf_ptr = (const u_char *)value;
            value_len = strlen(value);
        }
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (!_check_range(tp, value_len, &result, "Bad string length"))
            break;
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        snmp_pdu_add_variable(pdu, name, name_length, ASN_OCTET_STR,
                              buf_ptr, value_len);
        break;

    case 'n':
        snmp_pdu_add_variable(pdu, name, name_length, ASN_NULL, NULL, 0);
        break;

    case 'b':
#ifndef NETSNMP_DISABLE_MIB_LOADING
        if (check && (tp->type != TYPE_BITSTRING || !tp->enums)) {
            value = "BITS";
            result = SNMPERR_VALUE;
            goto type_error;
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
        tint = 0;
        if ((buf = (u_char *) malloc(256)) == NULL) {
            result = SNMPERR_MALLOC;
            break;
        } else {
            buf_len = 256;
            memset(buf, 0, buf_len);
        }

#ifndef NETSNMP_DISABLE_MIB_LOADING
        for (ep = tp ? tp->enums : NULL; ep; ep = ep->next) {
            if (ep->value / 8 >= (int) tint) {
                tint = ep->value / 8 + 1;
            }
        }
#endif /* NETSNMP_DISABLE_MIB_LOADING */

	vp = strdup(value);
	for (cp = strtok_r(vp, " ,\t", &st); cp; cp = strtok_r(NULL, " ,\t", &st)) {
            int             ix, bit;

            ltmp = strtoul(cp, &ecp, 0);
            if (*ecp != 0) {
#ifndef NETSNMP_DISABLE_MIB_LOADING
                for (ep = tp ? tp->enums : NULL; ep != NULL; ep = ep->next) {
                    if (strncmp(ep->label, cp, strlen(ep->label)) == 0) {
                        break;
                    }
                }
                if (ep != NULL) {
                    ltmp = ep->value;
                } else {
#endif /* NETSNMP_DISABLE_MIB_LOADING */
                    result = SNMPERR_RANGE;   /* ?? or SNMPERR_VALUE; */
                    snmp_set_detail(cp);
                    SNMP_FREE(buf);
		    SNMP_FREE(vp);
                    goto out;
#ifndef NETSNMP_DISABLE_MIB_LOADING
                }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
            }

            ix = ltmp / 8;
            if (ix >= (int) tint) {
                tint = ix + 1;
            }
            if (ix >= (int)buf_len && !snmp_realloc(&buf, &buf_len)) {
                result = SNMPERR_MALLOC;
                break;
            }
            bit = 0x80 >> ltmp % 8;
            buf[ix] |= bit;
	    
        }
	SNMP_FREE(vp);
        snmp_pdu_add_variable(pdu, name, name_length, ASN_OCTET_STR,
                              buf, tint);
        break;

#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case 'U':
        if (read64(&c64tmp, value))
            snmp_pdu_add_variable(pdu, name, name_length, ASN_OPAQUE_U64,
                                  &c64tmp, sizeof(c64tmp));
        else
            goto fail;
        break;

    case 'I':
        if (read64(&c64tmp, value))
            snmp_pdu_add_variable(pdu, name, name_length, ASN_OPAQUE_I64,
                                  &c64tmp, sizeof(c64tmp));
        else
            goto fail;
        break;

    case 'F':
        if (sscanf(value, "%f", &ftmp) == 1)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_OPAQUE_FLOAT,
                                  &ftmp, sizeof(ftmp));
        else
            goto fail;
        break;

    case 'D':
        if (sscanf(value, "%lf", &dtmp) == 1)
            snmp_pdu_add_variable(pdu, name, name_length, ASN_OPAQUE_DOUBLE,
                                  &dtmp, sizeof(dtmp));
        else
            goto fail;
        break;
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */

    default:
        result = SNMPERR_VAR_TYPE;
	buf = (u_char *)calloc(1, 4);
	if (buf != NULL) {
	    sprintf((char *)buf, "\"%c\"", type);
	    snmp_set_detail((char *)buf);
	}
        break;
    }

    SNMP_FREE(buf);
    SET_SNMP_ERROR(result);
    return result;

#ifndef NETSNMP_DISABLE_MIB_LOADING
  type_error:
    {
        char            error_msg[256];
        char            undef_msg[32];
        const char     *var_type;
        switch (tp->type) {
        case TYPE_OBJID:
            var_type = "OBJECT IDENTIFIER";
            break;
        case TYPE_OCTETSTR:
            var_type = "OCTET STRING";
            break;
        case TYPE_INTEGER:
            var_type = "INTEGER";
            break;
        case TYPE_NETADDR:
            var_type = "NetworkAddress";
            break;
        case TYPE_IPADDR:
            var_type = "IpAddress";
            break;
        case TYPE_COUNTER:
            var_type = "Counter32";
            break;
        case TYPE_GAUGE:
            var_type = "Gauge32";
            break;
        case TYPE_TIMETICKS:
            var_type = "Timeticks";
            break;
        case TYPE_OPAQUE:
            var_type = "Opaque";
            break;
        case TYPE_NULL:
            var_type = "Null";
            break;
        case TYPE_COUNTER64:
            var_type = "Counter64";
            break;
        case TYPE_BITSTRING:
            var_type = "BITS";
            break;
        case TYPE_NSAPADDRESS:
            var_type = "NsapAddress";
            break;
        case TYPE_UINTEGER:
            var_type = "UInteger";
            break;
        case TYPE_UNSIGNED32:
            var_type = "Unsigned32";
            break;
        case TYPE_INTEGER32:
            var_type = "Integer32";
            break;
        default:
            sprintf(undef_msg, "TYPE_%d", tp->type);
            var_type = undef_msg;
        }
//        snprintf(error_msg, sizeof(error_msg), "Type of attribute is %s, not %s", var_type, value);
        sprintf(error_msg, "Type of attribute is %s, not %s", var_type, value);
        error_msg[ sizeof(error_msg)-1 ] = 0;
        result = SNMPERR_VAR_TYPE;
        snmp_set_detail(error_msg);
        goto out;
    }
#endif /* NETSNMP_DISABLE_MIB_LOADING */
  fail:
    result = SNMPERR_VALUE;
    snmp_set_detail(value);
  out:
    SET_SNMP_ERROR(result);
    return result;
}

int snmp_res_lock(int groupID, int resourceID) {
	return 0;
}

int snmp_res_unlock(int groupID, int resourceID) {
	return 0;
} 

///**
// * probe for peer engineID
// *
// * @param slp         session list pointer.
// * @param in_session  session for errors
// *
// * @note
// *  - called by _sess_open(), snmp_sess_add_ex()
// *  - in_session is the user supplied session provided to those functions.
// *  - the first session in slp should the internal allocated copy of in_session
// *
// * @return 0 : error
// * @return 1 : ok
// *
// */
//int snmpv3_engineID_probe(struct session_list *slp, netsnmp_session * in_session) {
//    netsnmp_session *session;
//    int             status;
//    struct snmp_secmod_def *sptr = NULL;
//
//    if (slp == NULL || slp->session == NULL) {
//        return 0;
//    }
//
//    session = slp->session;
//    netsnmp_assert_or_return(session != NULL, 0);
//    sptr = find_sec_mod(session->securityModel);
//
//    /*
//     * If we are opening a V3 session and we don't know engineID we must probe
//     * it -- this must be done after the session is created and inserted in the
//     * list so that the response can handled correctly. 
//     */
//
//    if (session->version == SNMP_VERSION_3 &&
//        (0 == (session->flags & SNMP_FLAGS_DONT_PROBE))) {
//        if (NULL != sptr && NULL != sptr->probe_engineid) {
////            DEBUGMSGTL(("snmp_api", "probing for engineID using security model callback...\n")); // 101
//            /* security model specific mechanism of determining engineID */
//            status = (*sptr->probe_engineid) (slp, in_session);
//            if (status != SNMPERR_SUCCESS)
//                return 0;
//        } else {
//            /* XXX: default to the default RFC5343 contextEngineID Probe? */
//            return 0;
//        }
//    }
//
//    /* see if there was any hooks to call after the engineID probing */
//    if (sptr && sptr->post_probe_engineid) {
//        status = (*sptr->post_probe_engineid)(slp, in_session);
//        if (status != SNMPERR_SUCCESS)
//            return 0;
//    }
//
//    return 1;
//}

/*
 * u_char * snmp_build_var_op(
 * u_char *data      IN - pointer to the beginning of the output buffer
 * oid *var_name        IN - object id of variable 
 * int *var_name_len    IN - length of object id 
 * u_char var_val_type  IN - type of variable 
 * int    var_val_len   IN - length of variable 
 * u_char *var_val      IN - value of variable 
 * int *listlength      IN/OUT - number of valid bytes left in
 * output buffer 
 */

u_char *snmp_build_var_op(u_char * data, oid * var_name, size_t * var_name_len, u_char var_val_type, size_t var_val_len, u_char * var_val, size_t * listlength) {
    size_t          dummyLen, headerLen;
    u_char         *dataPtr;

    dummyLen = *listlength;
    dataPtr = data;
#if 0
    data = asn_build_sequence(data, &dummyLen, (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR), 0);
    if (data == NULL) {
        return NULL;
    }
#endif
    if (dummyLen < 4)
        return NULL;
    data += 4;
    dummyLen -= 4;

    headerLen = data - dataPtr;
    *listlength -= headerLen;
//    DEBUGDUMPHEADER("send", "Name");
    data = asn_build_objid(data, listlength,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_OBJECT_ID), var_name,
                           *var_name_len);
//    DEBUGINDENTLESS();
    if (data == NULL) {
//        ERROR_MSG("Can't build OID for variable");
        return NULL;
    }
//    DEBUGDUMPHEADER("send", "Value");
    switch (var_val_type) {
    case ASN_INTEGER:
        data = asn_build_int(data, listlength, var_val_type,
                             (long *) var_val, var_val_len);
        break;
    case ASN_GAUGE:
    case ASN_COUNTER:
    case ASN_TIMETICKS:
    case ASN_UINTEGER:
        data = asn_build_unsigned_int(data, listlength, var_val_type,
                                      (u_long *) var_val, var_val_len);
        break;
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_COUNTER64:
    case ASN_OPAQUE_U64:
#endif
    case ASN_COUNTER64:
        data = asn_build_unsigned_int64(data, listlength, var_val_type,
                                        (struct counter64 *) var_val,
                                        var_val_len);
        break;
    case ASN_OCTET_STR:
    case ASN_IPADDRESS:
    case ASN_OPAQUE:
    case ASN_NSAP:
        data = asn_build_string(data, listlength, var_val_type,
                                var_val, var_val_len);
        break;
    case ASN_OBJECT_ID:
        data = asn_build_objid(data, listlength, var_val_type,
                               (oid *) var_val, var_val_len / sizeof(oid));
        break;
    case ASN_NULL:
        data = asn_build_null(data, listlength, var_val_type);
        break;
    case ASN_BIT_STR:
        data = asn_build_bitstring(data, listlength, var_val_type,
                                   var_val, var_val_len);
        break;
    case SNMP_NOSUCHOBJECT:
    case SNMP_NOSUCHINSTANCE:
    case SNMP_ENDOFMIBVIEW:
        data = asn_build_null(data, listlength, var_val_type);
        break;
#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_FLOAT:
        data = asn_build_float(data, listlength, var_val_type,
                               (float *) var_val, var_val_len);
        break;
    case ASN_OPAQUE_DOUBLE:
        data = asn_build_double(data, listlength, var_val_type,
                                (double *) var_val, var_val_len);
        break;
    case ASN_OPAQUE_I64:
        data = asn_build_signed_int64(data, listlength, var_val_type,
                                      (struct counter64 *) var_val,
                                      var_val_len);
        break;
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
    default:
	{
	char error_buf[64];
//	snprintf(error_buf, sizeof(error_buf), "wrong type in snmp_build_var_op: %d", var_val_type);
	sprintf(error_buf, "wrong type in snmp_build_var_op: %d", var_val_type);
	ERROR_MSG(error_buf);
        data = NULL;
	}
    }
//    DEBUGINDENTLESS();
    if (data == NULL) {
        return NULL;
    }
    dummyLen = (data - dataPtr) - headerLen;

    asn_build_sequence(dataPtr, &dummyLen,
                       (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR),
                       dummyLen);
    return data;
} 

/*
 * on error, returns NULL (likely an encoding problem). 
 */
u_char * snmp_pdu_build(netsnmp_pdu *pdu, u_char * cp, size_t * out_length) {
    u_char         *h1, *h1e, *h2, *h2e;
    netsnmp_variable_list *vp;
    size_t          length;

    length = *out_length;
    /*
     * Save current location and build PDU tag and length placeholder
     * (actual length will be inserted later) 
     */
    h1 = cp;
    cp = asn_build_sequence(cp, out_length, (u_char) pdu->command, 0);
    if (cp == NULL)
        return NULL;
    h1e = cp;

    /*
     * store fields in the PDU preceeding the variable-bindings sequence 
     */
    if (pdu->command != SNMP_MSG_TRAP) {
        /*
         * PDU is not an SNMPv1 trap 
         */

//        DEBUGDUMPHEADER("send", "request_id");
        /*
         * request id 
         */
        cp = asn_build_int(cp, out_length,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_INTEGER), &pdu->reqid,
                           sizeof(pdu->reqid));
//        DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * error status (getbulk non-repeaters) 
         */
//        DEBUGDUMPHEADER("send", "error status");
        cp = asn_build_int(cp, out_length,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_INTEGER), &pdu->errstat,
                           sizeof(pdu->errstat));
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * error index (getbulk max-repetitions) 
         */
//        DEBUGDUMPHEADER("send", "error index");
        cp = asn_build_int(cp, out_length,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_INTEGER), &pdu->errindex,
                           sizeof(pdu->errindex));
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;
    } else {
        /*
         * an SNMPv1 trap PDU 
         */

        /*
         * enterprise 
         */
//        DEBUGDUMPHEADER("send", "enterprise OBJID");
        cp = asn_build_objid(cp, out_length,
                             (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                       ASN_OBJECT_ID),
                             (oid *) pdu->enterprise,
                             pdu->enterprise_length);
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * agent-addr 
         */
//        DEBUGDUMPHEADER("send", "agent Address");
        cp = asn_build_string(cp, out_length,
                              (u_char) (ASN_IPADDRESS | ASN_PRIMITIVE),
                              (u_char *) pdu->agent_addr, 4);
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * generic trap 
         */
//        DEBUGDUMPHEADER("send", "generic trap number");
        cp = asn_build_int(cp, out_length,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_INTEGER),
                           (long *) &pdu->trap_type,
                           sizeof(pdu->trap_type));
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * specific trap 
         */
//        DEBUGDUMPHEADER("send", "specific trap number");
        cp = asn_build_int(cp, out_length,
                           (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                     ASN_INTEGER),
                           (long *) &pdu->specific_type,
                           sizeof(pdu->specific_type));
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;

        /*
         * timestamp  
         */
//        DEBUGDUMPHEADER("send", "timestamp");
        cp = asn_build_unsigned_int(cp, out_length,
                                    (u_char) (ASN_TIMETICKS |
                                              ASN_PRIMITIVE), &pdu->time,
                                    sizeof(pdu->time));
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;
    }

    /*
     * Save current location and build SEQUENCE tag and length placeholder
     * for variable-bindings sequence
     * (actual length will be inserted later) 
     */
    h2 = cp;
    cp = asn_build_sequence(cp, out_length,
                            (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR), 0);
    if (cp == NULL)
        return NULL;
    h2e = cp;

    /*
     * Store variable-bindings 
     */
//    DEBUGDUMPSECTION("send", "VarBindList");
    for (vp = pdu->variables; vp; vp = vp->next_variable) {
//        DEBUGDUMPSECTION("send", "VarBind");
        cp = snmp_build_var_op(cp, vp->name, &vp->name_length, vp->type,
                               vp->val_len, (u_char *) vp->val.string,
                               out_length);
        //DEBUGINDENTLESS();
        if (cp == NULL)
            return NULL;
    }
    //DEBUGINDENTLESS();

    /*
     * insert actual length of variable-bindings sequence 
     */
    asn_build_sequence(h2, &length,
                       (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR),
                       cp - h2e);

    /*
     * insert actual length of PDU sequence 
     */
    asn_build_sequence(h1, &length, (u_char) pdu->command, cp - h1e);

    return cp;
} 

void snmp_free_varbind(netsnmp_variable_list * var) {
    netsnmp_variable_list *ptr;
    while (var) {
        ptr = var->next_variable;
        snmp_free_var(var);
        var = ptr;
    }
}
 
/*
 * Frees the pdu and any malloc'd data associated with it.
 */
void snmp_free_pdu(netsnmp_pdu *pdu) {
    struct snmp_secmod_def *sptr;

    if (!pdu)
        return;

    /*
     * If the command field is empty, that probably indicates
     *   that this PDU structure has already been freed.
     *   Log a warning and return (rather than freeing things again)
     *
     * Note that this does not pick up dual-frees where the
     *   memory is set to random junk, which is probably more serious.
     *
     * rks: while this is a good idea, there are two problems.
     *         1) agentx sets command to 0 in some cases
     *         2) according to Wes, a bad decode of a v3 message could
     *            result in a 0 at this offset.
     *      so I'm commenting it out until a better solution is found.
     *      note that I'm leaving the memset, below....
     *
    if (pdu->command == 0) {
        snmp_log(LOG_WARNING, "snmp_free_pdu probably called twice\n");
        return;
    }
     */
/*    if ((sptr = find_sec_mod(pdu->securityModel)) != NULL && // 101
        sptr->pdu_free != NULL) {
        (*sptr->pdu_free) (pdu);
    }
		*/
    snmp_free_varbind(pdu->variables);
    SNMP_FREE(pdu->enterprise);
    SNMP_FREE(pdu->community);
    SNMP_FREE(pdu->contextEngineID);
    SNMP_FREE(pdu->securityEngineID);
    SNMP_FREE(pdu->contextName);
    SNMP_FREE(pdu->securityName);
    SNMP_FREE(pdu->transport_data);
    memset(pdu, 0, sizeof(netsnmp_pdu));
    free((char *) pdu);
} 

#ifdef NETSNMP_USE_REVERSE_ASNENCODING
int snmp_realloc_rbuild_var_op(u_char ** pkt, size_t * pkt_len,
                           size_t * offset, int allow_realloc,
                           const oid * var_name, size_t * var_name_len,
                           u_char var_val_type,
                           u_char * var_val, size_t var_val_len)
{
    size_t          start_offset = *offset;
    int             rc = 0;

    /*
     * Encode the value.  
     */
    //DEBUGDUMPHEADER("send", "Value");

    switch (var_val_type) {
    case ASN_INTEGER:
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, allow_realloc,
                                    var_val_type, (long *) var_val,
                                    var_val_len);
        break;

    case ASN_GAUGE:
    case ASN_COUNTER:
    case ASN_TIMETICKS:
    case ASN_UINTEGER:
        rc = asn_realloc_rbuild_unsigned_int(pkt, pkt_len, offset,
                                             allow_realloc, var_val_type,
                                             (u_long *) var_val,
                                             var_val_len);
        break;

#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_COUNTER64:
    case ASN_OPAQUE_U64:
#endif
    case ASN_COUNTER64:
        rc = asn_realloc_rbuild_unsigned_int64(pkt, pkt_len, offset,
                                               allow_realloc, var_val_type,
                                               (struct counter64 *)
                                               var_val, var_val_len);
        break;

    case ASN_OCTET_STR:
    case ASN_IPADDRESS:
    case ASN_OPAQUE:
    case ASN_NSAP:
        rc = asn_realloc_rbuild_string(pkt, pkt_len, offset, allow_realloc,
                                       var_val_type, var_val, var_val_len);
        break;

    case ASN_OBJECT_ID:
        rc = asn_realloc_rbuild_objid(pkt, pkt_len, offset, allow_realloc,
                                      var_val_type, (oid *) var_val,
                                      var_val_len / sizeof(oid));
        break;

    case ASN_NULL:
        rc = asn_realloc_rbuild_null(pkt, pkt_len, offset, allow_realloc,
                                     var_val_type);
        break;

    case ASN_BIT_STR:
        rc = asn_realloc_rbuild_bitstring(pkt, pkt_len, offset,
                                          allow_realloc, var_val_type,
                                          var_val, var_val_len);
        break;

    case SNMP_NOSUCHOBJECT:
    case SNMP_NOSUCHINSTANCE:
    case SNMP_ENDOFMIBVIEW:
        rc = asn_realloc_rbuild_null(pkt, pkt_len, offset, allow_realloc,
                                     var_val_type);
        break;

#ifdef NETSNMP_WITH_OPAQUE_SPECIAL_TYPES
    case ASN_OPAQUE_FLOAT:
        rc = asn_realloc_rbuild_float(pkt, pkt_len, offset, allow_realloc,
                                      var_val_type, (float *) var_val,
                                      var_val_len);
        break;

    case ASN_OPAQUE_DOUBLE:
        rc = asn_realloc_rbuild_double(pkt, pkt_len, offset, allow_realloc,
                                       var_val_type, (double *) var_val,
                                       var_val_len);
        break;

    case ASN_OPAQUE_I64:
        rc = asn_realloc_rbuild_signed_int64(pkt, pkt_len, offset,
                                             allow_realloc, var_val_type,
                                             (struct counter64 *) var_val,
                                             var_val_len);
        break;
#endif                          /* NETSNMP_WITH_OPAQUE_SPECIAL_TYPES */
    default:
	{
	char error_buf[64];
//	snprintf(error_buf, sizeof(error_buf), "wrong type in snmp_realloc_rbuild_var_op: %d", var_val_type); 
	sprintf(error_buf, "wrong type in snmp_realloc_rbuild_var_op: %d", var_val_type); 
//        ERROR_MSG(error_buf);
        rc = 0;
	}
    }
    //DEBUGINDENTLESS();

    if (rc == 0) {
        return 0;
    }

    /*
     * Build the OID.  
     */

    //DEBUGDUMPHEADER("send", "Name");
    rc = asn_realloc_rbuild_objid(pkt, pkt_len, offset, allow_realloc,
                                  (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                            ASN_OBJECT_ID), var_name,
                                  *var_name_len);
    //DEBUGINDENTLESS();
    if (rc == 0) {
  //      ERROR_MSG("Can't build OID for variable");
        return 0;
    }

    /*
     * Build the sequence header.  
     */

    rc = asn_realloc_rbuild_sequence(pkt, pkt_len, offset, allow_realloc,
                                     (u_char) (ASN_SEQUENCE |
                                               ASN_CONSTRUCTOR),
                                     *offset - start_offset);
    return rc;
} 
/*
 * On error, returns 0 (likely an encoding problem).  
 */
int snmp_pdu_realloc_rbuild(u_char ** pkt, size_t * pkt_len, size_t * offset, netsnmp_pdu *pdu) {
#ifndef VPCACHE_SIZE
#define VPCACHE_SIZE 50
#endif
    netsnmp_variable_list *vpcache[VPCACHE_SIZE];
    netsnmp_variable_list *vp, *tmpvp;
    size_t          start_offset = *offset;
    int             i, wrapped = 0, notdone, final, rc = 0;

    //DEBUGMSGTL(("snmp_pdu_realloc_rbuild", "starting\n"));
    for (vp = pdu->variables, i = VPCACHE_SIZE - 1; vp;
         vp = vp->next_variable, i--) {
        if (i < 0) {
            wrapped = notdone = 1;
            i = VPCACHE_SIZE - 1;
            //DEBUGMSGTL(("snmp_pdu_realloc_rbuild", "wrapped\n"));
        }
        vpcache[i] = vp;
    }
    final = i + 1;

    do {
        for (i = final; i < VPCACHE_SIZE; i++) {
            vp = vpcache[i];
            //DEBUGDUMPSECTION("send", "VarBind");
            rc = snmp_realloc_rbuild_var_op(pkt, pkt_len, offset, 1,
                                            vp->name, &vp->name_length,
                                            vp->type,
                                            (u_char *) vp->val.string,
                                            vp->val_len);
            //DEBUGINDENTLESS();
            if (rc == 0) {
                return 0;
            }
        }

        //DEBUGINDENTLESS();
        if (wrapped) {
            notdone = 1;
            for (i = 0; i < final; i++) {
                vp = vpcache[i];
                //DEBUGDUMPSECTION("send", "VarBind");
                rc = snmp_realloc_rbuild_var_op(pkt, pkt_len, offset, 1,
                                                vp->name, &vp->name_length,
                                                vp->type,
                                                (u_char *) vp->val.string,
                                                vp->val_len);
                //DEBUGINDENTLESS();
                if (rc == 0) {
                    return 0;
                }
            }

            if (final == 0) {
                tmpvp = vpcache[VPCACHE_SIZE - 1];
            } else {
                tmpvp = vpcache[final - 1];
            }
            wrapped = 0;

            for (vp = pdu->variables, i = VPCACHE_SIZE - 1;
                 vp && vp != tmpvp; vp = vp->next_variable, i--) {
                if (i < 0) {
                    wrapped = 1;
                    i = VPCACHE_SIZE - 1;
                    //DEBUGMSGTL(("snmp_pdu_realloc_rbuild", "wrapped\n"));
                }
                vpcache[i] = vp;
            }
            final = i + 1;
        } else {
            notdone = 0;
        }
    } while (notdone);

    /*
     * Save current location and build SEQUENCE tag and length placeholder for
     * variable-bindings sequence (actual length will be inserted later).  
     */

    rc = asn_realloc_rbuild_sequence(pkt, pkt_len, offset, 1,
                                     (u_char) (ASN_SEQUENCE |
                                               ASN_CONSTRUCTOR),
                                     *offset - start_offset);

    /*
     * Store fields in the PDU preceeding the variable-bindings sequence.  
     */
    if (pdu->command != SNMP_MSG_TRAP) {
        /*
         * Error index (getbulk max-repetitions).  
         */
        //DEBUGDUMPHEADER("send", "error index");
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1,
                                    (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE
                                              | ASN_INTEGER),
                                    &pdu->errindex, sizeof(pdu->errindex));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Error status (getbulk non-repeaters).  
         */
        //DEBUGDUMPHEADER("send", "error status");
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1,
                                    (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE
                                              | ASN_INTEGER),
                                    &pdu->errstat, sizeof(pdu->errstat));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Request ID.  
         */
        //DEBUGDUMPHEADER("send", "request_id");
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1,
                                    (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE
                                              | ASN_INTEGER), &pdu->reqid,
                                    sizeof(pdu->reqid));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }
    } else {
        /*
         * An SNMPv1 trap PDU.  
         */

        /*
         * Timestamp.  
         */
        //DEBUGDUMPHEADER("send", "timestamp");
        rc = asn_realloc_rbuild_unsigned_int(pkt, pkt_len, offset, 1,
                                             (u_char) (ASN_TIMETICKS |
                                                       ASN_PRIMITIVE),
                                             &pdu->time,
                                             sizeof(pdu->time));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Specific trap.  
         */
        //DEBUGDUMPHEADER("send", "specific trap number");
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1,
                                    (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE
                                              | ASN_INTEGER),
                                    (long *) &pdu->specific_type,
                                    sizeof(pdu->specific_type));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Generic trap.  
         */
        //DEBUGDUMPHEADER("send", "generic trap number");
        rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1,
                                    (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE
                                              | ASN_INTEGER),
                                    (long *) &pdu->trap_type,
                                    sizeof(pdu->trap_type));
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Agent-addr.  
         */
        //DEBUGDUMPHEADER("send", "agent Address");
        rc = asn_realloc_rbuild_string(pkt, pkt_len, offset, 1,
                                       (u_char) (ASN_IPADDRESS |
                                                 ASN_PRIMITIVE),
                                       (u_char *) pdu->agent_addr, 4);
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }

        /*
         * Enterprise.  
         */
        //DEBUGDUMPHEADER("send", "enterprise OBJID");
        rc = asn_realloc_rbuild_objid(pkt, pkt_len, offset, 1,
                                      (u_char) (ASN_UNIVERSAL |
                                                ASN_PRIMITIVE |
                                                ASN_OBJECT_ID),
                                      (oid *) pdu->enterprise,
                                      pdu->enterprise_length);
        //DEBUGINDENTLESS();
        if (rc == 0) {
            return 0;
        }
    }

    /*
     * Build the PDU sequence.  
     */
    rc = asn_realloc_rbuild_sequence(pkt, pkt_len, offset, 1,
                                     (u_char) pdu->command,
                                     *offset - start_offset);
    return rc;
}
#endif                          /* NETSNMP_USE_REVERSE_ASNENCODING */ 

/*
 * Takes a session and a pdu and serializes the ASN PDU into the area
 * pointed to by *pkt.  *pkt_len is the size of the data area available.
 * Returns the length of the completed packet in *offset.  If any errors
 * occur, -1 is returned.  If all goes well, 0 is returned.
 */

static int _snmp_build(u_char ** pkt, size_t * pkt_len, size_t * offset, netsnmp_session * session, netsnmp_pdu *pdu) {
#if !defined(NETSNMP_DISABLE_SNMPV1) || !defined(NETSNMP_DISABLE_SNMPV2C)
    u_char         *h0e = NULL;
    size_t          start_offset = *offset;
    long            version;
    int             rc = 0;
#endif /* support for community based SNMP */
    
    u_char         *cp;
    size_t          length;

    session->s_snmp_errno = 0;
    session->s_errno = 0;

/* // 101
    if (pdu->version == SNMP_VERSION_3) {
        return snmpv3_build(pkt, pkt_len, offset, session, pdu);
    }
*/

    switch (pdu->command) {
    case SNMP_MSG_RESPONSE:
        netsnmp_assert(0 == (pdu->flags & UCD_MSG_FLAG_EXPECT_RESPONSE));
        /*
         * Fallthrough 
         */
#ifndef NETSNMP_NOTIFY_ONLY
    case SNMP_MSG_GET:
    case SNMP_MSG_GETNEXT:
#endif /* ! NETSNMP_NOTIFY_ONLY */
#ifndef NETSNMP_NO_WRITE_SUPPORT
    case SNMP_MSG_SET:
#endif /* !NETSNMP_NO_WRITE_SUPPORT */
        /*
         * all versions support these PDU types 
         */
        /*
         * initialize defaulted PDU fields 
         */

        if (pdu->errstat == SNMP_DEFAULT_ERRSTAT)
            pdu->errstat = 0;
        if (pdu->errindex == SNMP_DEFAULT_ERRINDEX)
            pdu->errindex = 0;
        break;

    case SNMP_MSG_TRAP2:
        netsnmp_assert(0 == (pdu->flags & UCD_MSG_FLAG_EXPECT_RESPONSE));
        /*
         * Fallthrough 
         */
    case SNMP_MSG_INFORM:
#ifndef NETSNMP_DISABLE_SNMPV1
        /*
         * not supported in SNMPv1 and SNMPsec 
         */
        if (pdu->version == SNMP_VERSION_1) {
            session->s_snmp_errno = SNMPERR_V2_IN_V1;
            return -1;
        }
#endif
        if (pdu->errstat == SNMP_DEFAULT_ERRSTAT)
            pdu->errstat = 0;
        if (pdu->errindex == SNMP_DEFAULT_ERRINDEX)
            pdu->errindex = 0;
        break;

#ifndef NETSNMP_NOTIFY_ONLY
    case SNMP_MSG_GETBULK:
        /*
         * not supported in SNMPv1 and SNMPsec 
         */
#ifndef NETSNMP_DISABLE_SNMPV1
        if (pdu->version == SNMP_VERSION_1) {
            session->s_snmp_errno = SNMPERR_V2_IN_V1;
            return -1;
        }
#endif
        if (pdu->max_repetitions < 0) {
            session->s_snmp_errno = SNMPERR_BAD_REPETITIONS;
            return -1;
        }
        if (pdu->non_repeaters < 0) {
            session->s_snmp_errno = SNMPERR_BAD_REPEATERS;
            return -1;
        }
        break;
#endif /* ! NETSNMP_NOTIFY_ONLY */

    case SNMP_MSG_TRAP:
        /*
         * *only* supported in SNMPv1 and SNMPsec 
         */
#ifndef NETSNMP_DISABLE_SNMPV1
        if (pdu->version != SNMP_VERSION_1) {
            session->s_snmp_errno = SNMPERR_V1_IN_V2;
            return -1;
        }
#endif
        /*
         * initialize defaulted Trap PDU fields 
         */
        pdu->reqid = 1;         /* give a bogus non-error reqid for traps */
        if (pdu->enterprise_length == SNMP_DEFAULT_ENTERPRISE_LENGTH) {
            pdu->enterprise = (oid *) malloc(sizeof(DEFAULT_ENTERPRISE));
            if (pdu->enterprise == NULL) {
                session->s_snmp_errno = SNMPERR_MALLOC;
                return -1;
            }
            memmove(pdu->enterprise, DEFAULT_ENTERPRISE,
                    sizeof(DEFAULT_ENTERPRISE));
            pdu->enterprise_length =
                sizeof(DEFAULT_ENTERPRISE) / sizeof(oid);
        }
        if (pdu->time == SNMP_DEFAULT_TIME)
            pdu->time = DEFAULT_TIME;
        /*
         * don't expect a response 
         */
        pdu->flags &= (~UCD_MSG_FLAG_EXPECT_RESPONSE);
        break;

    case SNMP_MSG_REPORT:      /* SNMPv3 only */
    default:
        session->s_snmp_errno = SNMPERR_UNKNOWN_PDU;
        return -1;
    }

    /*
     * save length 
     */
    length = *pkt_len;

    /*
     * setup administrative fields based on version 
     */
    /*
     * build the message wrapper and all the administrative fields
     * upto the PDU sequence
     * (note that actual length of message will be inserted later) 
     */
    switch (pdu->version) {
#ifndef NETSNMP_DISABLE_SNMPV1
    case SNMP_VERSION_1:
#endif
#ifndef NETSNMP_DISABLE_SNMPV2C
    case SNMP_VERSION_2c:
#endif
#if !defined(NETSNMP_DISABLE_SNMPV1) || !defined(NETSNMP_DISABLE_SNMPV2C)
#ifdef NETSNMP_NO_ZEROLENGTH_COMMUNITY
        if (pdu->community_len == 0) {
            if (session->community_len == 0) {
                session->s_snmp_errno = SNMPERR_BAD_COMMUNITY;
                return -1;
            }
            pdu->community = (u_char *) malloc(session->community_len);
            if (pdu->community == NULL) {
                session->s_snmp_errno = SNMPERR_MALLOC;
                return -1;
            }
            memmove(pdu->community,
                    session->community, session->community_len);
            pdu->community_len = session->community_len;
        }
#else                           /* !NETSNMP_NO_ZEROLENGTH_COMMUNITY */
        if (pdu->community_len == 0 && pdu->command != SNMP_MSG_RESPONSE) {
            /*
             * copy session community exactly to pdu community 
             */
            if (0 == session->community_len) {
                SNMP_FREE(pdu->community);
            } else if (pdu->community_len == session->community_len) {
                memmove(pdu->community,
                        session->community, session->community_len);
            } else {
                SNMP_FREE(pdu->community);
                pdu->community = (u_char *) malloc(session->community_len);
                if (pdu->community == NULL) {
                    session->s_snmp_errno = SNMPERR_MALLOC;
                    return -1;
                }
                memmove(pdu->community,
                        session->community, session->community_len);
            }
            pdu->community_len = session->community_len;
        }
#endif                          /* !NETSNMP_NO_ZEROLENGTH_COMMUNITY */

//        DEBUGMSGTL(("snmp_send", "Building SNMPv%ld message...\n", (1 + pdu->version)));
#ifdef NETSNMP_USE_REVERSE_ASNENCODING
        if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_REVERSE_ENCODE)) {
//            DEBUGPRINTPDUTYPE("send", pdu->command);
            rc = snmp_pdu_realloc_rbuild(pkt, pkt_len, offset, pdu);
            if (rc == 0) {
                return -1;
            }

//            DEBUGDUMPHEADER("send", "Community String");
            rc = asn_realloc_rbuild_string(pkt, pkt_len, offset, 1,
                                           (u_char) (ASN_UNIVERSAL |
                                                     ASN_PRIMITIVE |
                                                     ASN_OCTET_STR),
                                           pdu->community,
                                           pdu->community_len);
            //DEBUGINDENTLESS();
            if (rc == 0) {
                return -1;
            }


            /*
             * Store the version field.  
             */
//            DEBUGDUMPHEADER("send", "SNMP Version Number");

            version = pdu->version;
            rc = asn_realloc_rbuild_int(pkt, pkt_len, offset, 1, (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE | ASN_INTEGER), (long *) &version, sizeof(version));
            //DEBUGINDENTLESS();
            if (rc == 0) {
                return -1;
            }

            /*
             * Build the final sequence.  
             */
#ifndef NETSNMP_DISABLE_SNMPV1
            if (pdu->version == SNMP_VERSION_1) {
//                DEBUGDUMPSECTION("send", "SNMPv1 Message");
            } else {
#endif
//                DEBUGDUMPSECTION("send", "SNMPv2c Message");
#ifndef NETSNMP_DISABLE_SNMPV1
            }
#endif
            rc = asn_realloc_rbuild_sequence(pkt, pkt_len, offset, 1, (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR), *offset - start_offset);
//            DEBUGINDENTLESS();

            if (rc == 0) {
                return -1;
            }
            return 0;
        } else {

#endif                          /* NETSNMP_USE_REVERSE_ASNENCODING */
            /*
             * Save current location and build SEQUENCE tag and length
             * placeholder for SNMP message sequence
             * (actual length will be inserted later) 
             */
            cp = asn_build_sequence(*pkt, pkt_len, (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR), 0);
            if (cp == NULL) {
                return -1;
            }
            h0e = cp;

#ifndef NETSNMP_DISABLE_SNMPV1
            if (pdu->version == SNMP_VERSION_1) {
//                DEBUGDUMPSECTION("send", "SNMPv1 Message");
            } else {
#endif
//                DEBUGDUMPSECTION("send", "SNMPv2c Message");
#ifndef NETSNMP_DISABLE_SNMPV1
            }
#endif

            /*
             * store the version field 
             */
//            DEBUGDUMPHEADER("send", "SNMP Version Number");

            version = pdu->version;
            cp = asn_build_int(cp, pkt_len,
                               (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                         ASN_INTEGER), (long *) &version,
                               sizeof(version));
            //DEBUGINDENTLESS();
            if (cp == NULL)
                return -1;

            /*
             * store the community string 
             */
//            DEBUGDUMPHEADER("send", "Community String");
            cp = asn_build_string(cp, pkt_len,
                                  (u_char) (ASN_UNIVERSAL | ASN_PRIMITIVE |
                                            ASN_OCTET_STR), pdu->community,
                                  pdu->community_len);
            //DEBUGINDENTLESS();
            if (cp == NULL)
                return -1;
            break;

#ifdef NETSNMP_USE_REVERSE_ASNENCODING
        }
#endif                          /* NETSNMP_USE_REVERSE_ASNENCODING */
        break;
#endif /* support for community based SNMP */
    case SNMP_VERSION_2p:
    case SNMP_VERSION_sec:
    case SNMP_VERSION_2u:
    case SNMP_VERSION_2star:
    default:
        session->s_snmp_errno = SNMPERR_BAD_VERSION;
        return -1;
    }

//    DEBUGPRINTPDUTYPE("send", pdu->command);
    cp = snmp_pdu_build(pdu, cp, pkt_len);
    //DEBUGINDENTADD(-4);         /* return from entire v1/v2c message */
    if (cp == NULL)
        return -1;

    /*
     * insert the actual length of the message sequence 
     */
    switch (pdu->version) {
#ifndef NETSNMP_DISABLE_SNMPV1
    case SNMP_VERSION_1:
#endif
#ifndef NETSNMP_DISABLE_SNMPV2C
    case SNMP_VERSION_2c:
#endif
#if !defined(NETSNMP_DISABLE_SNMPV1) || !defined(NETSNMP_DISABLE_SNMPV2C)
        asn_build_sequence(*pkt, &length,
                           (u_char) (ASN_SEQUENCE | ASN_CONSTRUCTOR),
                           cp - h0e);
        break;
#endif /* support for community based SNMP */

    case SNMP_VERSION_2p:
    case SNMP_VERSION_sec:
    case SNMP_VERSION_2u:
    case SNMP_VERSION_2star:
    default:
        session->s_snmp_errno = SNMPERR_BAD_VERSION;
        return -1;
    }
    *pkt_len = cp - *pkt;
    return 0;
} 

int snmp_build(u_char ** pkt, size_t * pkt_len, size_t * offset, netsnmp_session * pss, netsnmp_pdu *pdu) {
    int             rc;
    rc = _snmp_build(pkt, pkt_len, offset, pss, pdu);
    if (rc) {
        if (!pss->s_snmp_errno) {
            snmp_log(LOG_ERR, "snmp_build: unknown failure");
            pss->s_snmp_errno = SNMPERR_BAD_ASN1_BUILD;
        }
        SET_SNMP_ERROR(pss->s_snmp_errno);
        rc = -1;
    }
    return rc;
}

/**
 * Query the current value of the monotonic clock.
 *
 * Returns the current value of a monotonic clock if such a clock is provided by
 * the operating system or the wall clock time if no such clock is provided by
 * the operating system. A monotonic clock is a clock that is never adjusted
 * backwards and that proceeds at the same rate as wall clock time.
 *
 * @param[out] tv Pointer to monotonic clock time.
 */
void netsnmp_get_monotonic_clock(struct timeval* tv) {
#if defined(HAVE_CLOCK_GETTIME) && defined(CLOCK_MONOTONIC)
    struct timespec ts;
    int res;

    res = clock_gettime(CLOCK_MONOTONIC, &ts);
    if (res >= 0) {
        tv->tv_sec = ts.tv_sec;
        tv->tv_usec = ts.tv_nsec / 1000;
    } else {
        netsnmp_assert(FALSE);
        memset(tv, 0, sizeof(*tv));
    }
#elif defined(WIN32)
    /*
     * Windows: return tick count. Note: the rate at which the tick count
     * increases is not adjusted by the time synchronization algorithm, so
     * expect an error of <= 100 ppm for the rate at which this clock
     * increases.
     */
    typedef ULONGLONG (WINAPI * pfGetTickCount64)(void);
    static int s_initialized;
    static pfGetTickCount64 s_pfGetTickCount64;
    uint64_t now64;

    if (!s_initialized) {
        HMODULE hKernel32 = GetModuleHandle("kernel32");
        s_pfGetTickCount64 =
            (pfGetTickCount64) GetProcAddress(hKernel32, "GetTickCount64");
        s_initialized = TRUE;
    }

    if (s_pfGetTickCount64) {
        /* Windows Vista, Windows 2008 or any later Windows version */
        now64 = (*s_pfGetTickCount64)();
    } else {
        /* Windows XP, Windows 2003 or any earlier Windows version */
        static uint32_t s_wraps, s_last;
        uint32_t now;

        now = GetTickCount();
        if (now < s_last)
            s_wraps++;
        s_last = now;
        now64 = ((uint64_t)s_wraps << 32) | now;
    }
    tv->tv_sec = now64 / 1000;
    tv->tv_usec = (now64 % 1000) * 1000;
#else

#endif
} 

/*
 * netsnmp_transport_peer_string
 *
 * returns string representation of peer address.
 *
 * caller is responsible for freeing the allocated string.
 */
char *
netsnmp_transport_peer_string(netsnmp_transport *t, void *data, int len)
{
    char           *str;

    if (NULL == t)
        return NULL;

    if (t->f_fmtaddr != NULL)
        str = t->f_fmtaddr(t, data, len);
    else
        str = strdup("<UNKNOWN>");

    return str;
} 

int
netsnmp_transport_send(netsnmp_transport *t, void *packet, int length,
                       void **opaque, int *olength)
{
    int dumpPacket, debugLength;

    if ((NULL == t) || (NULL == t->f_send)) {
//        DEBUGMSGTL(("transport:pkt:send", "NULL transport or send function\n"));
        return SNMPERR_GENERR;
    }
/* // 101
    dumpPacket = netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID,
                                        NETSNMP_DS_LIB_DUMP_PACKET);
    debugLength = (SNMPERR_SUCCESS ==
                   debug_is_token_registered("transport:send"));

    if (dumpPacket | debugLength) {
        char *str = netsnmp_transport_peer_string(t,
                                                  opaque ? *opaque : NULL,
                                                  olength ? *olength : 0);
        if (debugLength)
            DEBUGMSGT_NC(("transport:send","%lu bytes to %s\n", (unsigned long)length, str));
        if (dumpPacket)
            snmp_log(LOG_DEBUG, "\nSending %lu bytes to %s\n", 
                     (unsigned long)length, str);
        SNMP_FREE(str);
    }
    if (dumpPacket)
        xdump(packet, length, "");
*/
    return t->f_send(t, packet, length, opaque, olength);
}
 

static int _sess_async_send(void *sessp, netsnmp_pdu *pdu, snmp_callback callback, void *cb_data) {
    struct session_list *slp = (struct session_list *) sessp;
    netsnmp_session *session;
    struct snmp_internal_session *isp;
    netsnmp_transport *transport = NULL;
    u_char         *pktbuf = NULL, *packet = NULL;
    size_t          pktbuf_len = 0, offset = 0, length = 0;
    int             result;
    long            reqid;

    if (slp == NULL) {
        return 0;
    } else {
        session = slp->session;
        isp = slp->internal;
        transport = slp->transport;
        if (!session || !isp || !transport) {
            //DEBUGMSGTL(("sess_async_send", "send fail: closing...\n"));
            return 0;
        }
    }

    if (pdu == NULL) {
        session->s_snmp_errno = SNMPERR_NULL_PDU;
        return 0;
    }

    session->s_snmp_errno = 0;
    session->s_errno = 0;

    /*
     * Check/setup the version.  
     */
    if (pdu->version == SNMP_DEFAULT_VERSION) {
        if (session->version == SNMP_DEFAULT_VERSION) {
            session->s_snmp_errno = SNMPERR_BAD_VERSION;
            return 0;
        }
        pdu->version = session->version;
    } else if (session->version == SNMP_DEFAULT_VERSION) {
        /*
         * It's OK  
         */
    } else if (pdu->version != session->version) {
        /*
         * ENHANCE: we should support multi-lingual sessions  
         */
        session->s_snmp_errno = SNMPERR_BAD_VERSION;
        return 0;
    }

    /*
     * do we expect a response?
     */
    switch (pdu->command) {

        case SNMP_MSG_RESPONSE:
        case SNMP_MSG_TRAP:
        case SNMP_MSG_TRAP2:
        case SNMP_MSG_REPORT:
//        case AGENTX_MSG_CLEANUPSET:  // 101
//        case AGENTX_MSG_RESPONSE:
            pdu->flags &= ~UCD_MSG_FLAG_EXPECT_RESPONSE;
            break;
            
        default:
            pdu->flags |= UCD_MSG_FLAG_EXPECT_RESPONSE;
            break;
    }

    /*
     * check to see if we need a v3 engineID probe
     */
/*
    if ((pdu->version == SNMP_VERSION_3) &&
        (pdu->flags & UCD_MSG_FLAG_EXPECT_RESPONSE) &&
        (session->securityEngineIDLen == 0) &&
        (0 == (session->flags & SNMP_FLAGS_DONT_PROBE))) {
        int rc;
        DEBUGMSGTL(("snmpv3_build", "delayed probe for engineID\n"));
        rc = snmpv3_engineID_probe(slp, session);
        if (rc == 0)
            return 0; // s_snmp_errno already set 
    }
*/

    if ((pktbuf = (u_char *)malloc(2048)) == NULL) {
//        DEBUGMSGTL(("sess_async_send", "couldn't malloc initial packet buffer\n"));
        session->s_snmp_errno = SNMPERR_MALLOC;
        return 0;
    } else {
        pktbuf_len = 2048;
    }

#if TEMPORARILY_DISABLED
    /*
     *  NULL variable are allowed in certain PDU types.
     *  In particular, SNMPv3 engineID probes are of this form.
     *  There is an internal PDU flag to indicate that this
     *    is acceptable, but until the construction of engineID
     *    probes can be amended to set this flag, we'll simply
     *    skip this test altogether.
     */
    if (pdu->variables == NULL) {
        switch (pdu->command) {
#ifndef NETSNMP_NO_WRITE_SUPPORT
        case SNMP_MSG_SET:
#endif /* !NETSNMP_NO_WRITE_SUPPORT */
        case SNMP_MSG_GET:
        case SNMP_MSG_GETNEXT:
        case SNMP_MSG_GETBULK:
        case SNMP_MSG_RESPONSE:
        case SNMP_MSG_TRAP2:
        case SNMP_MSG_REPORT:
        case SNMP_MSG_INFORM:
            session->s_snmp_errno = snmp_errno = SNMPERR_NO_VARS;
            return 0;
        case SNMP_MSG_TRAP:
            break;
        }
    }
#endif


    /*
     * Build the message to send.  
     */
    if (isp->hook_realloc_build) {
        result = isp->hook_realloc_build(session, pdu,
                                         &pktbuf, &pktbuf_len, &offset);
        packet = pktbuf;
        length = offset;
    } else if (isp->hook_build) {
        packet = pktbuf;
        length = pktbuf_len;
        result = isp->hook_build(session, pdu, pktbuf, &length);
    } else {
#ifdef NETSNMP_USE_REVERSE_ASNENCODING
        if (netsnmp_ds_get_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_REVERSE_ENCODE)) {
            result =
                snmp_build(&pktbuf, &pktbuf_len, &offset, session, pdu);
            packet = pktbuf + pktbuf_len - offset;
            length = offset;
        } else {
#endif
            packet = pktbuf;
            length = pktbuf_len;
            result = snmp_build(&pktbuf, &length, &offset, session, pdu);
#ifdef NETSNMP_USE_REVERSE_ASNENCODING
        }
#endif
    }

    if (result < 0) {
//        DEBUGMSGTL(("sess_async_send", "encoding failure\n"));
        SNMP_FREE(pktbuf);
        return 0;
    }

    /*
     * Make sure we don't send something that is bigger than the msgMaxSize
     * specified in the received PDU.  
     */

    if (session->sndMsgMaxSize != 0 && length > session->sndMsgMaxSize) {
//        DEBUGMSGTL(("sess_async_send", "length of packet (%lu) exceeds session maximum (%lu)\n", (unsigned long)length, (unsigned long)session->sndMsgMaxSize));
        session->s_snmp_errno = SNMPERR_TOO_LONG;
        SNMP_FREE(pktbuf);
        return 0;
    }

    /*
     * Check that the underlying transport is capable of sending a packet as
     * large as length.  
     */

    if (transport->msgMaxSize != 0 && length > transport->msgMaxSize) {
//        DEBUGMSGTL(("sess_async_send", "length of packet (%lu) exceeds transport maximum (%lu)\n", (unsigned long)length, (unsigned long)transport->msgMaxSize));
        session->s_snmp_errno = SNMPERR_TOO_LONG;
        SNMP_FREE(pktbuf);
        return 0;
    }

    /*
     * Send the message.  
     */

//    DEBUGMSGTL(("sess_process_packet", "sending message id#%ld reqid#%ld len %"  NETSNMP_PRIz "u\n", pdu->msgid, pdu->reqid, length));
    result = netsnmp_transport_send(transport, packet, length, &(pdu->transport_data), &(pdu->transport_data_length));

    SNMP_FREE(pktbuf);

    if (result < 0) {
        session->s_snmp_errno = SNMPERR_BAD_SENDTO;
        session->s_errno = errno;
        return 0;
    }

    reqid = pdu->reqid;

    /*
     * Add to pending requests list if we expect a response.  
     */
    if (pdu->flags & UCD_MSG_FLAG_EXPECT_RESPONSE) {
        netsnmp_request_list *rp;
        struct timeval  tv;

        rp = (netsnmp_request_list *) calloc(1, sizeof(netsnmp_request_list));
        if (rp == NULL) {
            session->s_snmp_errno = SNMPERR_GENERR;
            return 0;
        }

        netsnmp_get_monotonic_clock(&tv);
        rp->pdu = pdu;
        rp->request_id = pdu->reqid;
        rp->message_id = pdu->msgid;
        rp->callback = callback;
        rp->cb_data = cb_data;
        rp->retries = 0;
        if (pdu->flags & UCD_MSG_FLAG_PDU_TIMEOUT) {
            rp->timeout = pdu->time * 1000000L;
        } else {
            rp->timeout = session->timeout;
        }
        rp->timeM = tv;
        tv.tv_usec += rp->timeout;
        tv.tv_sec += tv.tv_usec / 1000000L;
        tv.tv_usec %= 1000000L;
        rp->expireM = tv;

        /*
         * XX lock should be per session ! 
         */
        snmp_res_lock(MT_LIBRARY_ID, MT_LIB_SESSION);
        if (isp->requestsEnd) {
            rp->next_request = isp->requestsEnd->next_request;
            isp->requestsEnd->next_request = rp;
            isp->requestsEnd = rp;
        } else {
            rp->next_request = isp->requests;
            isp->requests = rp;
            isp->requestsEnd = rp;
        }
        snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_SESSION);
    } else {
        /*
         * No response expected...  
         */
        if (reqid) {
            /*
             * Free v1 or v2 TRAP PDU iff no error  
             */
            snmp_free_pdu(pdu);
        }
    }

    return reqid;
} 

int snmp_sess_async_send(void *sessp, netsnmp_pdu *pdu, snmp_callback callback, void *cb_data) {
    int             rc;

    if (sessp == NULL) {
        snmp_errno = SNMPERR_BAD_SESSION;       /*MTCRITICAL_RESOURCE */
        return (0);
    }
    /*
     * send pdu
     */
    rc = _sess_async_send(sessp, pdu, callback, cb_data);
    if (rc == 0) {
        struct session_list *psl;
        netsnmp_session *pss;
        psl = (struct session_list *) sessp;
        pss = psl->session;
        SET_SNMP_ERROR(pss->s_snmp_errno);
    }
    return rc;
}
 

/*
 * returns NULL or internal pointer to session
 * use this pointer for the other snmp_sess* routines,
 * which guarantee action will occur ONLY for this given session.
 */
void *snmp_sess_pointer(netsnmp_session * session) {
    struct session_list *slp;

    snmp_res_lock(MT_LIBRARY_ID, MT_LIB_SESSION);
    for (slp = Sessions; slp; slp = slp->next) {
        if (slp->session == session) {
            break;
        }
    }
    snmp_res_unlock(MT_LIBRARY_ID, MT_LIB_SESSION);

    if (slp == NULL) {
        snmp_errno = SNMPERR_BAD_SESSION;       /*MTCRITICAL_RESOURCE */
        return (NULL);
    }
    return ((void *) slp);
} 
/*
 * These functions send PDUs using an active session:
 * snmp_send             - traditional API, no callback
 * snmp_async_send       - traditional API, with callback
 * snmp_sess_send        - single session API, no callback
 * snmp_sess_async_send  - single session API, with callback
 *
 * Call snmp_build to create a serialized packet (the pdu).
 * If necessary, set some of the pdu data from the
 * session defaults.
 * If there is an expected response for this PDU,
 * queue a corresponding request on the list
 * of outstanding requests for this session,
 * and store the callback vectors in the request.
 *
 * Send the pdu to the target identified by this session.
 * Return on success:
 *   The request id of the pdu is returned, and the pdu is freed.
 * Return on failure:
 *   Zero (0) is returned.
 *   The caller must call snmp_free_pdu if 0 is returned.
 */
int snmp_async_send(netsnmp_session * session, netsnmp_pdu *pdu, snmp_callback callback, void *cb_data) {
    void *sessp = snmp_sess_pointer(session);
    return snmp_sess_async_send(sessp, pdu, callback, cb_data);
}
 
int snmp_send(netsnmp_session * session, netsnmp_pdu *pdu) {
    return snmp_async_send(session, pdu, NULL, NULL);
} 

char *winsock_startup(void) {
    WORD            VersionRequested;
    WSADATA         stWSAData;
    int             i;
    static char     errmsg[100];

	/* winsock 1: use MAKEWORD(1,1) */
	/* winsock 2: use MAKEWORD(2,2) */

    VersionRequested = MAKEWORD(2,2);
    i = WSAStartup(VersionRequested, &stWSAData);
    if (i != 0) {
        if (i == WSAVERNOTSUPPORTED)
            sprintf(errmsg, "Unable to init. socket lib, does not support 1.1");
        else {
            sprintf(errmsg, "Socket Startup error %d", i);
        }
        return (errmsg);
    }
    return (NULL);
}

void winsock_cleanup(void) {
    WSACleanup();
}
 
const char* skip_white_const(const char *ptr) {
    if (ptr == NULL)
        return (NULL);
    while (*ptr != 0 && isspace((unsigned char)*ptr))
        ptr++;
    if (*ptr == 0 || *ptr == '#')
        return (NULL);
    return (ptr);
}
 

const char *copy_nword_const(const char *from, char *to, int len) {
    char            quote;
    if (!from || !to)
        return NULL;
    if ((*from == '\"') || (*from == '\'')) {
        quote = *(from++);
        while ((*from != quote) && (*from != 0)) {
            if ((*from == '\\') && (*(from + 1) != 0)) {
                if (len > 0) {  /* don't copy beyond len bytes */
                    *to++ = *(from + 1);
                    if (--len == 0)
                        *(to - 1) = '\0';       /* null protect the last spot */
                }
                from = from + 2;
            } else {
                if (len > 0) {  /* don't copy beyond len bytes */
                    *to++ = *from++;
                    if (--len == 0)
                        *(to - 1) = '\0';       /* null protect the last spot */
                } else
                    from++;
            }
        }
        if (*from == 0) {
//            DEBUGMSGTL(("read_config_copy_word", "no end quote found in config string\n"));
        } else
            from++;
    } else {
        while (*from != 0 && !isspace((unsigned char)(*from))) {
            if ((*from == '\\') && (*(from + 1) != 0)) {
                if (len > 0) {  /* don't copy beyond len bytes */
                    *to++ = *(from + 1);
                    if (--len == 0)
                        *(to - 1) = '\0';       /* null protect the last spot */
                }
                from = from + 2;
            } else {
                if (len > 0) {  /* don't copy beyond len bytes */
                    *to++ = *from++;
                    if (--len == 0)
                        *(to - 1) = '\0';       /* null protect the last spot */
                } else
                    from++;
            }
        }
    }
    if (len > 0)
        *to = 0;
    from = skip_white_const(from);
    return (from);
}                               /* copy_nword */ 

static char** create_word_array_helper(const char* cptr, size_t idx, char* tmp, size_t tmplen) {
    char* item;
    char** res;
    cptr = copy_nword_const(cptr, tmp, tmplen);
    item = strdup(tmp);
    if (cptr)
        res = create_word_array_helper(cptr, idx + 1, tmp, tmplen);
    else {
        res = (char**)malloc(sizeof(char*) * (idx + 2));
        res[idx + 1] = NULL;
    }
    res[idx] = item;
    return res;
} 

static char** create_word_array(const char* cptr) {
    size_t tmplen = strlen(cptr);
    char* tmp = (char*)malloc(tmplen + 1);
    char** res = create_word_array_helper(cptr, 0, tmp, tmplen + 1);
    free(tmp);
    return res;
}
 
static void destroy_word_array(char** arr) {
    if (arr) {
        char** run = arr;
        while(*run) {
            free(*run);
            ++run;
        }
        free(arr);
    }
}

struct netsnmp_lookup_domain {
    char* application;
    char** userDomain;
    char** domain;
    struct netsnmp_lookup_domain* next;
};

static struct netsnmp_lookup_domain* domains = NULL; 

int
netsnmp_register_default_domain(const char* application, const char* domain)
{
    struct netsnmp_lookup_domain *run = domains, *prev = NULL;
    int res = 0;

    while (run != NULL && strcmp(run->application, application) < 0) {
	prev = run;
	run = run->next;
    }
    if (run && strcmp(run->application, application) == 0) {
      if (run->domain != NULL) {
          destroy_word_array(run->domain);
	  run->domain = NULL;
	  res = 1;
      }
    } else {
	run = SNMP_MALLOC_STRUCT(netsnmp_lookup_domain);
	run->application = strdup(application);
	run->userDomain = NULL;
	if (prev) {
	    run->next = prev->next;
	    prev->next = run;
	} else {
	    run->next = domains;
	    domains = run;
	}
    }
    if (domain) {
        run->domain = create_word_array(domain);
    } else if (run->userDomain == NULL) {
	if (prev)
	    prev->next = run->next;
	else
	    domains = run->next;
	free(run->application);
	free(run);
    }
    return res;
}

static char _init_snmp_init_done = 0;
static void _init_snmp(void) {

    struct timeval  tv;
    long            tmpReqid, tmpMsgid;

    if (_init_snmp_init_done)
        return;
    _init_snmp_init_done = 1;
    Reqid = 1;

    snmp_res_init();            /* initialize the mt locking structures */

#ifndef NETSNMP_DISABLE_MIB_LOADING
    netsnmp_init_mib_internals();
#endif /* NETSNMP_DISABLE_MIB_LOADING */
    netsnmp_tdomain_init();

//    gettimeofday(&tv, (struct timezone *) 0);
//    /*
//     * Now = tv;
//     */
//
//    /*
//     * get pseudo-random values for request ID and message ID 
//     */
//#ifdef SVR4
//    srand48(tv.tv_sec ^ tv.tv_usec);
//    tmpReqid = lrand48();
//    tmpMsgid = lrand48();
//#else
//    srandom((unsigned)(tv.tv_sec ^ tv.tv_usec));
//    tmpReqid = random();
//    tmpMsgid = random();
//#endif

    tmpReqid = rand();
    tmpMsgid = rand();


    /*
     * don't allow zero value to repeat init 
     */
    if (tmpReqid == 0)
        tmpReqid = 1;
    if (tmpMsgid == 0)
        tmpMsgid = 1;
    Reqid = tmpReqid;
    Msgid = tmpMsgid;

    netsnmp_register_default_domain("snmp", "udp udp6");
    netsnmp_register_default_domain("snmptrap", "udp udp6");

    netsnmp_register_default_target("snmp", "udp", ":161");
    netsnmp_register_default_target("snmp", "tcp", ":161");
    netsnmp_register_default_target("snmp", "udp6", ":161");
    netsnmp_register_default_target("snmp", "tcp6", ":161");
    netsnmp_register_default_target("snmp", "dtlsudp", ":10161");
    netsnmp_register_default_target("snmp", "tlstcp", ":10161");
    netsnmp_register_default_target("snmp", "ipx", "/36879");

    netsnmp_register_default_target("snmptrap", "udp", ":162");
    netsnmp_register_default_target("snmptrap", "tcp", ":162");
    netsnmp_register_default_target("snmptrap", "udp6", ":162");
    netsnmp_register_default_target("snmptrap", "tcp6", ":162");
    netsnmp_register_default_target("snmptrap", "dtlsudp", ":10162");
    netsnmp_register_default_target("snmptrap", "tlstcp", ":10162");
    netsnmp_register_default_target("snmptrap", "ipx", "/36880");

    netsnmp_ds_set_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_HEX_OUTPUT_LENGTH, 16);
    netsnmp_ds_set_int(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_RETRIES, DEFAULT_RETRIES);

#ifdef NETSNMP_USE_REVERSE_ASNENCODING
    netsnmp_ds_set_boolean(NETSNMP_DS_LIBRARY_ID, NETSNMP_DS_LIB_REVERSE_ENCODE, NETSNMP_DEFAULT_ASNENCODING_DIRECTION);
#endif
} 

void snmp_sess_init(netsnmp_session * session) {
    _init_snmp();

    /*
     * initialize session to default values 
     */

    memset(session, 0, sizeof(netsnmp_session));
    session->remote_port = SNMP_DEFAULT_REMPORT;
    session->timeout = SNMP_DEFAULT_TIMEOUT;
    session->retries = SNMP_DEFAULT_RETRIES;
    session->version = SNMP_DEFAULT_VERSION;
    session->securityModel = SNMP_DEFAULT_SECMODEL;
    session->rcvMsgMaxSize = SNMP_MAX_MSG_SIZE;
    session->flags |= SNMP_FLAGS_DONT_PROBE;
} 

/*
 * generic statistics counter functions 
 */
static u_int    statistics[NETSNMP_STAT_MAX_STATS];

u_int snmp_increment_statistic(int which) {
    if (which >= 0 && which < NETSNMP_STAT_MAX_STATS) {
        statistics[which]++;
        return statistics[which];
    }
    return 0;
}
 

/**
 * Captures responses or the lack there of from INFORMs that were sent
 * 1) a response is received from an INFORM
 * 2) one isn't received and the retries/timeouts have failed
*/
int
handle_inform_response(int op, netsnmp_session * session, int reqid, netsnmp_pdu *pdu, void *magic) {
    /* XXX: possibly stats update */
    switch (op) {

    case NETSNMP_CALLBACK_OP_RECEIVED_MESSAGE:
        snmp_increment_statistic(STAT_SNMPINPKTS);
//        DEBUGMSGTL(("trap", "received the inform response for reqid=%d\n", reqid));
        break;

    case NETSNMP_CALLBACK_OP_TIMED_OUT:
//        DEBUGMSGTL(("trap", "received a timeout sending an inform for reqid=%d\n", reqid));
        break;

    case NETSNMP_CALLBACK_OP_SEND_FAILED:
//        DEBUGMSGTL(("trap", "failed to send an inform for reqid=%d\n", reqid));
        break;

    default:
//        DEBUGMSGTL(("trap", "received op=%d for reqid=%d when trying to send an inform\n", op, reqid));
			;
    }

    return 1;
} 

/*
 * Copy some or all variables from source PDU to target PDU.
 * This function consolidates many of the needs of PDU variables:
 * Clone PDU : copy all the variables.
 * Split PDU : skip over some variables to copy other variables.
 * Fix PDU   : remove variable associated with error index.
 *
 * Designed to work with _clone_pdu_header.
 *
 * If drop_err is set, drop any variable associated with errindex.
 * If skip_count is set, skip the number of variable in pdu's list.
 * While copy_count is greater than zero, copy pdu variables to newpdu.
 *
 * If an error occurs, newpdu is freed and pointer is set to 0.
 *
 * Returns a pointer to the cloned PDU if successful.
 * Returns 0 if failure.
 */
static
netsnmp_pdu    *
_copy_pdu_vars(netsnmp_pdu *pdu,        /* source PDU */
               netsnmp_pdu *newpdu,     /* target PDU */
               int drop_err,    /* !=0 drop errored variable */
               int skip_count,  /* !=0 number of variables to skip */
               int copy_count)
{                               /* !=0 number of variables to copy */
    netsnmp_variable_list *var;
#if TEMPORARILY_DISABLED
    int             copied;
#endif
    int             drop_idx;

    if (!newpdu)
        return NULL;            /* where is PDU to copy to ? */

    if (drop_err)
        drop_idx = pdu->errindex - skip_count;
    else
        drop_idx = 0;

    var = pdu->variables;
    while (var && (skip_count-- > 0))   /* skip over pdu variables */
        var = var->next_variable;

#if TEMPORARILY_DISABLED
    copied = 0;
    if (pdu->flags & UCD_MSG_FLAG_FORCE_PDU_COPY)
        copied = 1;             /* We're interested in 'empty' responses too */
#endif

    newpdu->variables = _copy_varlist(var, drop_idx, copy_count);
#if TEMPORARILY_DISABLED
    if (newpdu->variables)
        copied = 1;
#endif

#if ALSO_TEMPORARILY_DISABLED
    /*
     * Error if bad errindex or if target PDU has no variables copied 
     */
    if ((drop_err && (ii < pdu->errindex))
#if TEMPORARILY_DISABLED
        /*
         * SNMPv3 engineID probes are allowed to be empty.
         * See the comment in snmp_api.c for further details 
         */
        || copied == 0
#endif
        ) {
        snmp_free_pdu(newpdu);
        return 0;
    }
#endif
    return newpdu;
} 

//int usm_clone_usmStateReference(struct usmStateReference *from, struct usmStateReference **to) {
//    struct usmStateReference *cloned_usmStateRef;
//
//    if (from == NULL || to == NULL)
//        return -1;
//
//    *to = usm_malloc_usmStateReference();
//    cloned_usmStateRef = *to;
//
//    if (usm_set_usmStateReference_name(cloned_usmStateRef, from->usr_name, from->usr_name_length) ||
//        usm_set_usmStateReference_engine_id(cloned_usmStateRef, from->usr_engine_id, from->usr_engine_id_length) ||
//        usm_set_usmStateReference_auth_protocol(cloned_usmStateRef, from->usr_auth_protocol, from->usr_auth_protocol_length) ||
//        usm_set_usmStateReference_auth_key(cloned_usmStateRef, from->usr_auth_key, from->usr_auth_key_length) ||
//        usm_set_usmStateReference_priv_protocol(cloned_usmStateRef, from->usr_priv_protocol, from->usr_priv_protocol_length) ||
//        usm_set_usmStateReference_priv_key(cloned_usmStateRef, from->usr_priv_key, from->usr_priv_key_length) ||
//        usm_set_usmStateReference_sec_level(cloned_usmStateRef, from->usr_sec_level))
//    {
//        usm_free_usmStateReference(*to);
//        *to = NULL;
//        return -1;
//    }
//
//    return 0;
//
//} 

/*
 * Creates and allocates a clone of the input PDU,
 * but does NOT copy the variables.
 * This function should be used with another function,
 * such as _copy_pdu_vars.
 *
 * Returns a pointer to the cloned PDU if successful.
 * Returns 0 if failure.
 */
static netsnmp_pdu* _clone_pdu_header(netsnmp_pdu *pdu) {
    netsnmp_pdu    *newpdu;
    struct snmp_secmod_def *sptr;
    int ret;

    newpdu = (netsnmp_pdu *) malloc(sizeof(netsnmp_pdu));
    if (!newpdu)
        return NULL;
    memmove(newpdu, pdu, sizeof(netsnmp_pdu));

    /*
     * reset copied pointers if copy fails 
     */
    newpdu->variables = NULL;
    newpdu->enterprise = NULL;
    newpdu->community = NULL;
    newpdu->securityEngineID = NULL;
    newpdu->securityName = NULL;
    newpdu->contextEngineID = NULL;
    newpdu->contextName = NULL;
    newpdu->transport_data = NULL;

    /*
     * copy buffers individually. If any copy fails, all are freed. 
     */
    if (snmp_clone_mem((void **) &newpdu->enterprise, pdu->enterprise,
                       sizeof(oid) * pdu->enterprise_length) ||
        snmp_clone_mem((void **) &newpdu->community, pdu->community,
                       pdu->community_len) ||
        snmp_clone_mem((void **) &newpdu->contextEngineID,
                       pdu->contextEngineID, pdu->contextEngineIDLen)
        || snmp_clone_mem((void **) &newpdu->securityEngineID,
                          pdu->securityEngineID, pdu->securityEngineIDLen)
        || snmp_clone_mem((void **) &newpdu->contextName, pdu->contextName,
                          pdu->contextNameLen)
        || snmp_clone_mem((void **) &newpdu->securityName,
                          pdu->securityName, pdu->securityNameLen)
        || snmp_clone_mem((void **) &newpdu->transport_data,
                          pdu->transport_data,
                          pdu->transport_data_length)) {
        snmp_free_pdu(newpdu);
        return NULL;
    }

    if (pdu != NULL && pdu->securityStateRef &&
        pdu->command == SNMP_MSG_TRAP2) {

        ret = usm_clone_usmStateReference((struct usmStateReference *) pdu->securityStateRef, (struct usmStateReference **) &newpdu->securityStateRef );

        if (ret)
        {
            snmp_free_pdu(newpdu);
            return 0;
        }
    }

    if ((sptr = find_sec_mod(newpdu->securityModel)) != NULL &&
        sptr->pdu_clone != NULL) {
        /*
         * call security model if it needs to know about this 
         */
        (*sptr->pdu_clone) (pdu, newpdu);
    }

    return newpdu;
} 

/*
 * Creates (allocates and copies) a clone of the input PDU.
 * If drop_err is set, don't copy any variable associated with errindex.
 * This function is called by snmp_clone_pdu and snmp_fix_pdu.
 *
 * Returns a pointer to the cloned PDU if successful.
 * Returns 0 if failure.
 */
static netsnmp_pdu* _clone_pdu(netsnmp_pdu *pdu, int drop_err) {
    netsnmp_pdu    *newpdu;
    newpdu = _clone_pdu_header(pdu);
    newpdu = _copy_pdu_vars(pdu, newpdu, drop_err, 0, 10000);   /* skip none, copy all */

    return newpdu;
}
 
/*
 * This function will clone a PDU including all of its variables.
 *
 * Returns a pointer to the cloned PDU if successful.
 * Returns 0 if failure
 */
netsnmp_pdu *snmp_clone_pdu(netsnmp_pdu *pdu) {
    return _clone_pdu(pdu, 0);  /* copies all variables */
}
 

/*
 * send_trap_to_sess: sends a trap to a session but assumes that the
 * pdu is constructed correctly for the session type. 
 */
void send_trap_to_sess(netsnmp_session * sess, netsnmp_pdu *template_pdu) {
    netsnmp_pdu    *pdu;
    int            result;

    if (!sess || !template_pdu)
        return;

//    DEBUGMSGTL(("trap", "sending trap type=%d, version=%ld\n", template_pdu->command, sess->version));

#ifndef NETSNMP_DISABLE_SNMPV1
    if (sess->version == SNMP_VERSION_1 && (template_pdu->command != SNMP_MSG_TRAP))
        return;                 /* Skip v1 sinks for v2 only traps */
    if (sess->version != SNMP_VERSION_1 && (template_pdu->command == SNMP_MSG_TRAP))
        return;                 /* Skip v2+ sinks for v1 only traps */
#endif
    template_pdu->version = sess->version;
    pdu = snmp_clone_pdu(template_pdu);
    pdu->sessid = sess->sessid; /* AgentX only ? */

    if ( template_pdu->command == SNMP_MSG_INFORM
#ifdef USING_AGENTX_PROTOCOL_MODULE
         || template_pdu->command == AGENTX_MSG_NOTIFY
#endif
       ) {
        result =
            snmp_async_send(sess, pdu, &handle_inform_response, NULL);
        
    } else {
        if ((sess->version == SNMP_VERSION_3) && (pdu->command == SNMP_MSG_TRAP2) && (sess->securityEngineIDLen == 0)) {
            //u_char          tmp[SPRINT_MAX_LEN];
            //int len = snmpv3_get_engineID(tmp, sizeof(tmp));
            //memdup(&pdu->securityEngineID, tmp, len);
            //pdu->securityEngineIDLen = len;
        }

        result = snmp_send(sess, pdu);
    }

    if (result == 0) {
//        snmp_sess_perror("snmpd: send_trap", sess);
        snmp_free_pdu(pdu);
    } else {
        snmp_increment_statistic(STAT_SNMPOUTTRAPS);
        snmp_increment_statistic(STAT_SNMPOUTPKTS);
    }
}