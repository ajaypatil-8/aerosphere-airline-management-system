<%@ page import="java.util.*, com.skyconnect.servlet.SearchFlightsServlet.FlightRow" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Search Results - SkyConnect</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="navbar">
  <div class="brand">✈ SkyConnect</div>
  <div>
    <a href="index.jsp">Home</a>
    <a href="userDashboard">Dashboard</a>
    <a href="userBookings">My Bookings</a>
    <a href="logout">Logout</a>
  </div>
</div>

<div class="container">
  <div class="card">
    <h2>Available Flights</h2>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
      <p style="color:red;"><%= error %></p>
    <%
      }
      List<FlightRow> flights = (List<FlightRow>) request.getAttribute("flights");
      Integer numSeats = (Integer) request.getAttribute("numSeats");
      if (numSeats == null) numSeats = 1;
    %>

    <%
      if (flights == null || flights.isEmpty()) {
    %>
        <p>No flights found for the selected route/date.</p>
    <%
      } else {
    %>
      <table class="table">
        <tr>
          <th>Flight No</th>
          <th>From</th>
          <th>To</th>
          <th>Date</th>
          <th>Time</th>
          <th>Price</th>
          <th>Seats Avl</th>
          <th>Action</th>
        </tr>
        <%
          for (FlightRow f : flights) {
        %>
          <tr>
            <td><%= f.flightNo %></td>
            <td><%= f.source %></td>
            <td><%= f.destination %></td>
            <td><%= f.departDate %></td>
            <td><%= f.departTime %></td>
            <td>₹ <%= f.price %></td>
            <td><%= f.seatsAvailable %></td>
            <td>
              <form action="bookFlight" method="post" style="margin:0;">
                <input type="hidden" name="flightId" value="<%= f.id %>">
                <input type="hidden" name="numSeats" value="<%= numSeats %>">
                <button type="submit" class="btn">Book</button>
              </form>
            </td>
          </tr>
        <%
          }
        %>
      </table>
    <%
      }
    %>
  </div>
</div>

</body>
</html>
