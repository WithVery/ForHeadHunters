/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author admin
 */

import java.util.Scanner;

public class UserInterface {
    private TodoList todolist;
    private Scanner scanner;
    
    public UserInterface(TodoList todoList, Scanner scanner) {
        this.todolist = todoList;
        this.scanner = scanner;
    }
    
    public void start() {
        
        while(true) {
            System.out.println("Command: ");
            String command = scanner.nextLine();
            if(command.equals("stop")) {
                break;
            } else if (command.equals("add")) {
                System.out.println("To add: ");
                String task = scanner.nextLine(); 
                todolist.add(task);
            } else if (command.equals("list")) {
                todolist.print();
            } else if (command.equals("remove")) {
                System.out.println("Which one is removed? ");   
                Integer number = Integer.valueOf(scanner.nextLine());
                todolist.remove(number);
            }
        }
        
    }
    
}
