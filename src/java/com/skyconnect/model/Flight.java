package com.skyconnect.model;

import java.sql.Date;
import java.sql.Time;

public class Flight {
    private int id;
    private String flightNo;
    private String source;
    private String destination;
    private Date departDate;
    private Time departTime;
    private Time arrivalTime;
    private double price;
    private int seatsTotal;
    private int seatsAvailable;

    public Flight() {}

    // ---------- Getters ----------
    public int getId()               { return id; }
    public String getFlightNo()      { return flightNo; }
    public String getSource()        { return source; }
    public String getDestination()   { return destination; }
    public Date getDepartDate()      { return departDate; }
    public Time getDepartTime()      { return departTime; }
    public Time getArrivalTime()     { return arrivalTime; }
    public double getPrice()         { return price; }
    public int getSeatsTotal()       { return seatsTotal; }
    public int getSeatsAvailable()   { return seatsAvailable; }

    /** Duration string e.g. "2h 15m" */
    public String getDuration() {
        if (departTime == null || arrivalTime == null) return "N/A";
        long diffSec = (arrivalTime.getTime() - departTime.getTime()) / 1000;
        if (diffSec < 0) diffSec += 86400; // crosses midnight
        long h = diffSec / 3600;
        long m = (diffSec % 3600) / 60;
        return h + "h " + m + "m";
    }

    // ---------- Setters ----------
    public void setId(int id)                      { this.id = id; }
    public void setFlightNo(String flightNo)       { this.flightNo = flightNo; }
    public void setSource(String source)           { this.source = source; }
    public void setDestination(String dest)        { this.destination = dest; }
    public void setDepartDate(Date departDate)     { this.departDate = departDate; }
    public void setDepartTime(Time departTime)     { this.departTime = departTime; }
    public void setArrivalTime(Time arrivalTime)   { this.arrivalTime = arrivalTime; }
    public void setPrice(double price)             { this.price = price; }
    public void setSeatsTotal(int seatsTotal)      { this.seatsTotal = seatsTotal; }
    public void setSeatsAvailable(int seatsAvail)  { this.seatsAvailable = seatsAvail; }
}