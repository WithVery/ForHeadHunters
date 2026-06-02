import java.util.ArrayList;
import java.util.Collections;

public class Hand implements Comparable<Hand> {
    private ArrayList<Card> cards;

    public Hand() {
        cards = new ArrayList<>();
    }
    
    public void add(Card card) {
        cards.add(card);
    }
    
    public void print() {
//        cards.stream().sorted().forEach(System.out::println);
        cards.stream().forEach(System.out::println);
    }
    
    public void sort() {
        Collections.sort(cards);
    }
    
    public void sortBySuit() {
        //Collections.sort(cards, (c1, c2) -> c1.getSuit().ordinal() - c2.getSuit().ordinal());
        Collections.sort(cards, new BySuitInValueOrder());
    }
    
    public ArrayList<Card> getCards() {
        return cards;
    }
    
    @Override
    public int compareTo(Hand hand) {
        return this.getCards().stream().mapToInt(card -> card.getValue()).sum() - hand.getCards().stream().mapToInt(card -> card.getValue()).sum();
    }
}
