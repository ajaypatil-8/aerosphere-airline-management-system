package com.skyconnect.model;

import java.sql.Date;

public class Passenger {
    private int id;
    private int bookingId;
    private String fullName;
    private int age;
    private String gender;
    private String phone;
    private String email;
    private Date dob;
    private String seatNo;

    public Passenger() {}

    // ---------- Getters ----------
    public int getId()           { return id; }
    public int getBookingId()    { return bookingId; }
    public String getFullName()  { return fullName; }
    public int getAge()          { return age; }
    public String getGender()    { return gender; }
    public String getPhone()     { return phone; }
    public String getEmail()     { return email; }
    public Date getDob()         { return dob; }
    public String getSeatNo()    { return seatNo; }

    // ---------- Setters ----------
    public void setId(int id)                { this.id = id; }
    public void setBookingId(int bookingId)  { this.bookingId = bookingId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setAge(int age)              { this.age = age; }
    public void setGender(String gender)     { this.gender = gender; }
    public void setPhone(String phone)       { this.phone = phone; }
    public void setEmail(String email)       { this.email = email; }
    public void setDob(Date dob)             { this.dob = dob; }
    public void setSeatNo(String seatNo)     { this.seatNo = seatNo; }
}