package com.skyconnect.model;

import java.sql.Timestamp;

public class Refund {
    private int id;
    private int bookingId;
    private int userId;
    private double refundAmount;
    private String refundReason;
    private String refundStatus;    // PENDING | APPROVED | REJECTED
    private Timestamp approvedAt;
    private Timestamp requestedAt;

    // Extra join fields
    private String userName;
    private String flightNo;
    private String source;
    private String destination;

    public Refund() {}

    public int getId()                  { return id; }
    public int getBookingId()           { return bookingId; }
    public int getUserId()              { return userId; }
    public double getRefundAmount()     { return refundAmount; }
    public String getRefundReason()     { return refundReason; }
    public String getRefundStatus()     { return refundStatus; }
    public Timestamp getApprovedAt()    { return approvedAt; }
    public Timestamp getRequestedAt()   { return requestedAt; }
    public String getUserName()         { return userName; }
    public String getFlightNo()         { return flightNo; }
    public String getSource()           { return source; }
    public String getDestination()      { return destination; }

    public void setId(int id)                          { this.id = id; }
    public void setBookingId(int bookingId)            { this.bookingId = bookingId; }
    public void setUserId(int userId)                  { this.userId = userId; }
    public void setRefundAmount(double refundAmount)   { this.refundAmount = refundAmount; }
    public void setRefundReason(String refundReason)   { this.refundReason = refundReason; }
    public void setRefundStatus(String refundStatus)   { this.refundStatus = refundStatus; }
    public void setApprovedAt(Timestamp approvedAt)    { this.approvedAt = approvedAt; }
    public void setRequestedAt(Timestamp requestedAt)  { this.requestedAt = requestedAt; }
    public void setUserName(String userName)           { this.userName = userName; }
    public void setFlightNo(String flightNo)           { this.flightNo = flightNo; }
    public void setSource(String source)               { this.source = source; }
    public void setDestination(String dest)            { this.destination = dest; }
}