package FlightControl.ui;

import java.util.Scanner;
import java.util.Collection;
import FlightControl.logic.FlightControl;
import FlightControl.domain.Airplane;
import FlightControl.domain.Flight;

public class TextUI {
    private FlightControl flightControl;
    private Scanner scanner;

    public TextUI(FlightControl flightControl, Scanner scanner) {
        this.flightControl = flightControl;
        this.scanner = scanner;
    }

    public void start() {
        startAssetControl();
        System.out.println("");
        startFlightControl();
    }
    
    public void startAssetControl() {
        System.out.println("Airport Asset Control");
//        System.out.println("--------------------");
//        System.out.println();

        while(true) {
//            System.out.println("Choose an action:");
            System.out.println("[1] Add an airplane");
            System.out.println("[2] Add a flight");
            System.out.println("[x] Exit Airport Asset Control");

            System.out.print("> ");
            
            String command = scanner.nextLine();
            
            if(command.equals("1")) {
                addAirplane(scanner);
            } else if(command.equals("2")) {
                addFlight(scanner);
            } else if(command.equals("x")) {
                break;
            }
        }
    }
    
    public void addAirplane(Scanner scanner) {
        System.out.println("Give the airplane id: ");
        String airplane = scanner.nextLine();
        System.out.println("Give the airplane capacity: ");
        int capacity = Integer.valueOf(scanner.nextLine());
        flightControl.addAirplane(airplane, capacity);
    }
    
    public void addFlight(Scanner scanner) {
        System.out.println("Give the airplane id: ");
        Airplane airplane = askForAirplane();
        
        if(airplane == null) return;
        
        System.out.println("Give the departure airport id: ");
        String departure = scanner.nextLine();
        
        System.out.println("Give the target airport id: ");
        String destination = scanner.nextLine();
        
        flightControl.addFlight(airplane, departure, destination);
        
    }

    public Airplane askForAirplane() {
        return flightControl.getAirplane(scanner.nextLine());
    }

    public void startFlightControl() {
        System.out.println("Flight Control");
        while(true) {
//            System.out.println("Choose an action:");
            System.out.println("[1] Print airplanes");
            System.out.println("[2] Print flights");
            System.out.println("[3] Print airplane details");
            System.out.println("[x] Quit");
            System.out.println(">");
            
            String command = scanner.nextLine();
            
            if(command.equals("1")) {
                printAirplanes();
            } else if(command.equals("2")) {
                printFlights();
            } else if(command.equals("3")) {
                printAirplaneDetails();
            } else if(command.equals("x")) {
                break;
            }
        }
    }
    
    public void printAirplanes() {
        Collection<Airplane> airplanes = flightControl.getAirplanes();
//        airplanes.stream().forEach(System.out::println);
        for(Airplane airplane: airplanes) System.out.println(airplane);
//        System.out.println("");
    }
    
    public void printFlights() {
        Collection<Flight> flights = flightControl.getFlights();
//        flights.stream().forEach(System.out::println);
        for(Flight flight: flights) System.out.println(flight);
        System.out.println("");
    }
    
    public void printAirplaneDetails() {
        System.out.print("Give the airplane id: ");
        Airplane airplane = askForAirplane();
        if(airplane != null) System.out.println(airplane);
//        System.out.println("");
    }
}
