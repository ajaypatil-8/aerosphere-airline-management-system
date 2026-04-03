package com.skyconnect.model;

import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int flightId;
    private Timestamp bookingDate;
    private int numSeats;
    private double totalAmount;
    private String status;          // PENDING | BOOKED | CANCELLED
    private String paymentStatus;   // PENDING | SUCCESS | FAILED | REFUNDED
    private Timestamp cancelledAt;
    private String razorpayOrderId;

    // Extra join fields (not in DB, populated by DAO queries)
    private String flightNo;
    private String source;
    private String destination;
    private String departDate;
    private String departTime;
    private String userName;

    public Booking() {}

    // ---------- Getters ----------
    public int getId()                  { return id; }
    public int getUserId()              { return userId; }
    public int getFlightId()            { return flightId; }
    public Timestamp getBookingDate()   { return bookingDate; }
    public int getNumSeats()            { return numSeats; }
    public double getTotalAmount()      { return totalAmount; }
    public String getStatus()           { return status; }
    public String getPaymentStatus()    { return paymentStatus; }
    public Timestamp getCancelledAt()   { return cancelledAt; }
    public String getRazorpayOrderId()  { return razorpayOrderId; }
    public String getFlightNo()         { return flightNo; }
    public String getSource()           { return source; }
    public String getDestination()      { return destination; }
    public String getDepartDate()       { return departDate; }
    public String getDepartTime()       { return departTime; }
    public String getUserName()         { return userName; }

    // ---------- Setters ----------
    public void setId(int id)                          { this.id = id; }
    public void setUserId(int userId)                  { this.userId = userId; }
    public void setFlightId(int flightId)              { this.flightId = flightId; }
    public void setBookingDate(Timestamp t)            { this.bookingDate = t; }
    public void setNumSeats(int numSeats)              { this.numSeats = numSeats; }
    public void setTotalAmount(double totalAmount)     { this.totalAmount = totalAmount; }
    public void setStatus(String status)               { this.status = status; }
    public void setPaymentStatus(String ps)            { this.paymentStatus = ps; }
    public void setCancelledAt(Timestamp t)            { this.cancelledAt = t; }
    public void setRazorpayOrderId(String id)          { this.razorpayOrderId = id; }
    public void setFlightNo(String flightNo)           { this.flightNo = flightNo; }
    public void setSource(String source)               { this.source = source; }
    public void setDestination(String dest)            { this.destination = dest; }
    public void setDepartDate(String departDate)       { this.departDate = departDate; }
    public void setDepartTime(String departTime)       { this.departTime = departTime; }
    public void setUserName(String userName)           { this.userName = userName; }
}