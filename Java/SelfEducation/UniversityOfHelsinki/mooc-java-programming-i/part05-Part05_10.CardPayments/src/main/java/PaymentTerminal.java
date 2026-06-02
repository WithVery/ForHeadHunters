
public class PaymentTerminal {


    private double money;  // amount of cash
    private int affordableMeals; // number of sold affordable meals
    private int heartyMeals;  // number of sold hearty meals


    public PaymentTerminal() {
        // register initially has 1000 euros of money
        money = 1000;
    }

    public double eatAffordably(double payment) {
        // an affordable meal costs 2.50 euros
        // increase the amount of cash by the price of an affordable mean and return the change
        // if the payment parameter is not large enough, no meal is sold and the method should return the whole payment
        if(2.50 <= payment) {
            money += 2.50;
            affordableMeals++;
            return payment - 2.50;
        }
        else {
            return payment;
        }
    }

    public double eatHeartily(double payment) {
        // a hearty meal costs 4.30 euros
        // increase the amount of cash by the price of a hearty mean and return the change
        // if the payment parameter is not large enough, no meal is sold and the method should return the whole payment
        if(4.30 <= payment) {
            money += 4.30;
            heartyMeals++;
            return payment - 4.30;
        }
        else {
            return payment;
        }
    }

    private boolean eat(PaymentCard card, double amount) {
        if(amount <= card.balance()) {
//            money += amount;
            card.takeMoney(amount);
            return true;
        }
        else {
            return false;
        }
    }
    
    public boolean eatAffordably(PaymentCard card) {
        if(eat(card, 2.50)) {
            affordableMeals++;
            return true;
        }
        else {
            return false;
        }
    }

    public boolean eatHeartily(PaymentCard card) {
        if(eat(card, 4.30)) {
            heartyMeals++;
            return true;
        }
        else {
            return false;
        }
    }

    public void addMoneyToCard(PaymentCard card, double sum) {
        if(0<sum) {
            money+=sum;
            card.addMoney(sum);
        }
    }    

    @Override
    public String toString() {
        return "money: " + money + ", number of sold affordable meals: " + affordableMeals + ", number of sold hearty meals: " + heartyMeals;
    }
}
