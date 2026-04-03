package com.skyconnect.model;

import java.sql.Timestamp;

public class Payment {
    private int id;
    private int bookingId;
    private double amount;
    private String paymentMethod;
    private String paymentStatus;
    private Timestamp paymentDate;
    private String razorpayOrderId;
    private String razorpayPaymentId;
    private String razorpaySignature;

    public Payment() {}

    public int getId()                      { return id; }
    public int getBookingId()               { return bookingId; }
    public double getAmount()               { return amount; }
    public String getPaymentMethod()        { return paymentMethod; }
    public String getPaymentStatus()        { return paymentStatus; }
    public Timestamp getPaymentDate()       { return paymentDate; }
    public String getRazorpayOrderId()      { return razorpayOrderId; }
    public String getRazorpayPaymentId()    { return razorpayPaymentId; }
    public String getRazorpaySignature()    { return razorpaySignature; }

    public void setId(int id)                              { this.id = id; }
    public void setBookingId(int bookingId)                { this.bookingId = bookingId; }
    public void setAmount(double amount)                   { this.amount = amount; }
    public void setPaymentMethod(String paymentMethod)     { this.paymentMethod = paymentMethod; }
    public void setPaymentStatus(String paymentStatus)     { this.paymentStatus = paymentStatus; }
    public void setPaymentDate(Timestamp paymentDate)      { this.paymentDate = paymentDate; }
    public void setRazorpayOrderId(String id)              { this.razorpayOrderId = id; }
    public void setRazorpayPaymentId(String id)            { this.razorpayPaymentId = id; }
    public void setRazorpaySignature(String sig)           { this.razorpaySignature = sig; }
}