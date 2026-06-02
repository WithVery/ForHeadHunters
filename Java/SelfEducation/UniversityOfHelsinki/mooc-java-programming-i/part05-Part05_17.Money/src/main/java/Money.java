
public class Money {

    private final int euros;
    private final int cents;

    public Money(int euros, int cents) {

        if (cents > 99) {
            euros = euros + cents / 100;
            cents = cents % 100;
        }

        this.euros = euros;
        this.cents = cents;
    }

    public int euros() {
        return this.euros;
    }

    public int cents() {
        return this.cents;
    }

    public Money plus(Money addition) {
        return new Money(this.euros + addition.euros + (this.cents + addition.cents)/100, (this.cents + addition.cents) % 100);
    }
    
    public boolean lessThan(Money compared) {
        return (this.euros * 100 + this.cents) < (compared.euros * 100 + compared.cents);
    }
    
    public Money minus(Money decreaser) {
        if(this.lessThan(decreaser)) {
            return new Money(0,0);
        } else {
            int cnts = this.cents;
            int eurs = this.euros;
            if(this.cents < decreaser.cents) {
                cnts += 100;
                eurs--;
            }
            return new Money(eurs-decreaser.euros, cnts - decreaser.cents);
        }
    }
            
    @Override
    public String toString() {
        String zero = "";
        if (this.cents < 10) {
            zero = "0";
        }

        return this.euros + "." + zero + this.cents + "e";
    }

}
