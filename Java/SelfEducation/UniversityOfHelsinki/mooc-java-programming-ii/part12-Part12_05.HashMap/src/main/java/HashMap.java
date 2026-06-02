public class HashMap<K,V> {
   private List<Pair<K,V>>[] values;
   private int amount;

    public HashMap() {
        values = new List[32];
        amount = 0;
    }
    
    
    public V get(K key) {
        int hash = key.hashCode() % values.length;
        if(values[hash] == null) return null;
        
        List<Pair<K,V>> pairs = values[hash];
        for(int i = 0; i < pairs.size(); i++) 
            if (pairs.value(i).getKey().equals(key))
                return pairs.value(i).getValue();
        
        return null;
    }
   
    public List<Pair<K,V>> getListByKey(K key) {
        int hash = key.hashCode() % values.length;
        
        if(values[hash] == null)
            values[hash] = new List<>();
        
        return values[hash];
    }
    
    public int getIndexByKey(List<Pair<K,V>> list, K key) {
        for(int i = 0; i<list.size(); i++) {
            if(list.value(i).getKey().equals(key)) return i;
        }
        return -1;
    }
    
    public void add(K key, V value) {
        List<Pair<K,V>> pairs = getListByKey(key);
        
        for(int i = 0; i < pairs.size(); i++) 
            if (pairs.value(i).getKey().equals(key)) {
                pairs.value(i).setValue(value);
                return;
            }
        
        pairs.add(new Pair(key, value));
        amount++;
        if(amount * 4 / 3 > values.length)
            grow();
    }

    private void grow() {
        List<Pair<K,V>>[] newValues = new List[values.length * 2];
        for(int i = 0; i < values.length; i++) {
            copy(newValues, values[i]);
        }
    }
    
    private void copy(List<Pair<K,V>>[] newArray, List<Pair<K,V>> oldList) {
        for(int i = 0; i < oldList.size(); i++) {
            Pair<K,V> pair = oldList.value(i);
            int hashCode = Math.abs(pair.getKey().hashCode() % newArray.length);
            
            //List<Pair<K,V>> list = newArray[hashCode];
            if (newArray[hashCode] == null)
                newArray[hashCode] = new List<>();
            
            newArray[hashCode].add(pair);
        }
    }

    public V remove(K key) {
        List<Pair<K,V>> list = getListByKey(key);
        if(list == null) return null;
        
        int idx = getIndexByKey(list, key);
        
        if(idx < 0) {
            return null;
        } else {
            V value = list.value(idx).getValue();
            list.remove(idx);
            return value;
        } 
    }
    
}
