package com.skyconnect.controller;

import com.skyconnect.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/reportFlights")
public class ReportFlightsServlet extends HttpServlet {

    public static class FlightRow {
        public int id;
        public String flightNo;
        public String source;
        public String destination;
        public Date departDate;
        public Time departTime;
        public Time arrivalTime;
        public double price;
        public int totalSeats;
        public int availableSeats;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String route = req.getParameter("route");        // Mumbai-Delhi
        String departDate = req.getParameter("date");   // yyyy-mm-dd

        List<FlightRow> flights = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {

            StringBuilder sql = new StringBuilder(
                "SELECT id, flight_no, source, destination, depart_date, depart_time, " +
                "arrival_time, price, seats_total, seats_available FROM flights WHERE 1=1"
            );

            if (route != null && !route.isEmpty()) {
                sql.append(" AND CONCAT(source,'-',destination) = ?");
            }

            if (departDate != null && !departDate.isEmpty()) {
                sql.append(" AND depart_date = ?");
            }

            sql.append(" ORDER BY depart_date DESC");

            PreparedStatement ps = con.prepareStatement(sql.toString());

            int index = 1;

            if (route != null && !route.isEmpty()) {
                ps.setString(index++, route);
            }

            if (departDate != null && !departDate.isEmpty()) {
                ps.setDate(index++, Date.valueOf(departDate));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                FlightRow f = new FlightRow();
                f.id = rs.getInt("id");
                f.flightNo = rs.getString("flight_no");
                f.source = rs.getString("source");
                f.destination = rs.getString("destination");
                f.departDate = rs.getDate("depart_date");
                f.departTime = rs.getTime("depart_time");
                f.arrivalTime = rs.getTime("arrival_time");
                f.price = rs.getDouble("price");
                f.totalSeats = rs.getInt("seats_total");
                f.availableSeats = rs.getInt("seats_available");
                flights.add(f);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("flights", flights);
        req.getRequestDispatcher("/Views/admin/flights_report.jsp").forward(req, resp);
    }
}