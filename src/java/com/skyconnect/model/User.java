package com.skyconnect.model;

import java.sql.Date;
import java.sql.Timestamp;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String phone;
    private Date dob;
    private String gender;
    private String address;
    private String role;
    private Timestamp createdAt;

    public User() {}

    // ---------- Getters ----------
    public int getId()              { return id; }
    public String getName()         { return name; }
    public String getEmail()        { return email; }
    public String getPassword()     { return password; }
    public String getPhone()        { return phone; }
    public Date getDob()            { return dob; }
    public String getGender()       { return gender; }
    public String getAddress()      { return address; }
    public String getRole()         { return role; }
    public Timestamp getCreatedAt() { return createdAt; }

    // ---------- Setters ----------
    public void setId(int id)                    { this.id = id; }
    public void setName(String name)             { this.name = name; }
    public void setEmail(String email)           { this.email = email; }
    public void setPassword(String password)     { this.password = password; }
    public void setPhone(String phone)           { this.phone = phone; }
    public void setDob(Date dob)                 { this.dob = dob; }
    public void setGender(String gender)         { this.gender = gender; }
    public void setAddress(String address)       { this.address = address; }
    public void setRole(String role)             { this.role = role; }
    public void setCreatedAt(Timestamp t)        { this.createdAt = t; }
}