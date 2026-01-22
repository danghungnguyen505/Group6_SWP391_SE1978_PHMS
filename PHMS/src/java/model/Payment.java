/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author TrungNguyen2002
 */
public class Payment {
     private int id;
    private int invoiceId;
    private String method; // CASH, VNPAY
    private String status; // SUCCESS, FAILED, PENDING
}
