package com.skyconnect.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import java.io.OutputStream;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AeroSphere — PdfInvoiceService
 *
 * Generates a professional, branded PDF invoice using iText 5.
 *
 * JAR needed (add to WEB-INF/lib):
 *   itextpdf-5.5.13.3.jar
 *   Download: https://repo1.maven.org/maven2/com/itextpdf/itextpdf/5.5.13.3/itextpdf-5.5.13.3.jar
 *
 * Maven (if using pom.xml):
 *   <dependency>
 *     <groupId>com.itextpdf</groupId>
 *     <artifactId>itextpdf</artifactId>
 *     <version>5.5.13.3</version>
 *   </dependency>
 *
 * Called from InvoiceServlet when ?download=true is in the URL.
 */
public class PdfInvoiceService {

    private static final Logger LOG = Logger.getLogger(PdfInvoiceService.class.getName());

    // Brand color — emerald green as RGB
    private static final BaseColor EMERALD     = new BaseColor(16, 185, 129);
    private static final BaseColor EMERALD_LIGHT = new BaseColor(209, 250, 229);
    private static final BaseColor DARK_TEXT   = new BaseColor(28, 25, 23);
    private static final BaseColor MUTED       = new BaseColor(107, 114, 128);
    private static final BaseColor BORDER      = new BaseColor(229, 231, 235);
    private static final BaseColor LIGHT_BG    = new BaseColor(249, 250, 251);

    private PdfInvoiceService() {}

    /**
     * Writes a complete PDF invoice to the provided OutputStream.
     *
     * @param out         HttpServletResponse.getOutputStream()
     * @param bookingId   e.g. 42
     * @param userName    Passenger name
     * @param userEmail   Passenger email
     * @param flightNo    e.g. SK101
     * @param source      e.g. Mumbai
     * @param destination e.g. Delhi
     * @param departDate  e.g. 10 Apr 2026
     * @param departTime  e.g. 06:00
     * @param arrivalTime e.g. 08:15
     * @param numSeats    number of seats
     * @param baseAmount  base ticket price
     * @param gstAmount   GST (5%)
     * @param totalAmount final charged amount
     * @param paymentMethod e.g. UPI
     * @param passengers  list of PassengerRow objects (name, age, gender, seatNo)
     */
    public static void generate(
            OutputStream out,
            int bookingId, String userName, String userEmail,
            String flightNo, String source, String destination,
            String departDate, String departTime, String arrivalTime,
            int numSeats, double baseAmount, double gstAmount, double totalAmount,
            String paymentMethod, List<PassengerRow> passengers) {

        try {
            Document doc = new Document(PageSize.A4, 40, 40, 50, 50);
            PdfWriter writer = PdfWriter.getInstance(doc, out);
            doc.open();

            // ── Fonts ──────────────────────────────────────────────
            Font titleFont   = FontFactory.getFont(FontFactory.HELVETICA_BOLD,   20, EMERALD);
            Font headerFont  = FontFactory.getFont(FontFactory.HELVETICA_BOLD,   11, BaseColor.WHITE);
            Font labelFont   = FontFactory.getFont(FontFactory.HELVETICA_BOLD,    9, MUTED);
            Font valueFont   = FontFactory.getFont(FontFactory.HELVETICA,         10, DARK_TEXT);
            Font valueBold   = FontFactory.getFont(FontFactory.HELVETICA_BOLD,   10, DARK_TEXT);
            Font smallMuted  = FontFactory.getFont(FontFactory.HELVETICA,          8, MUTED);
            Font sectionFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD,   10, DARK_TEXT);
            Font amtFont     = FontFactory.getFont(FontFactory.HELVETICA_BOLD,   14, EMERALD);

            // ── HEADER BAR ─────────────────────────────────────────
            PdfPTable headerBar = new PdfPTable(2);
            headerBar.setWidthPercentage(100);
            headerBar.setWidths(new float[]{1.2f, 1f});

            // Logo cell
            PdfPCell logoCell = new PdfPCell();
            logoCell.setBackgroundColor(EMERALD);
            logoCell.setBorder(Rectangle.NO_BORDER);
            logoCell.setPadding(14);
            Paragraph brand = new Paragraph("✈  AeroSphere", titleFont);
            brand.setAlignment(Element.ALIGN_LEFT);
            logoCell.addElement(brand);
            Paragraph tagline = new Paragraph("Your Premium Airline Booking Partner",
                FontFactory.getFont(FontFactory.HELVETICA, 8, new BaseColor(167, 243, 208)));
            logoCell.addElement(tagline);
            headerBar.addCell(logoCell);

            // Invoice meta cell
            PdfPCell metaCell = new PdfPCell();
            metaCell.setBackgroundColor(new BaseColor(5, 150, 105)); // darker emerald
            metaCell.setBorder(Rectangle.NO_BORDER);
            metaCell.setPadding(14);
            metaCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            Font whiteFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, BaseColor.WHITE);
            Font whiteSm   = FontFactory.getFont(FontFactory.HELVETICA, 9, new BaseColor(167, 243, 208));
            Paragraph invoiceTitle = new Paragraph("BOOKING INVOICE", whiteFont);
            invoiceTitle.setAlignment(Element.ALIGN_RIGHT);
            metaCell.addElement(invoiceTitle);
            Paragraph invoiceNo = new Paragraph("# " + String.format("%06d", bookingId), whiteSm);
            invoiceNo.setAlignment(Element.ALIGN_RIGHT);
            metaCell.addElement(invoiceNo);
            headerBar.addCell(metaCell);

            doc.add(headerBar);
            doc.add(Chunk.NEWLINE);

            // ── PASSENGER & FLIGHT INFO ────────────────────────────
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingBefore(6);
            infoTable.setWidths(new float[]{1f, 1f});

            // Passenger info block
            PdfPCell passengerBlock = infoBlock(
                "PASSENGER DETAILS",
                new String[]{"Name", "Email", "Seats Booked"},
                new String[]{userName, userEmail, String.valueOf(numSeats)},
                labelFont, valueFont
            );
            infoTable.addCell(passengerBlock);

            // Flight info block
            PdfPCell flightBlock = infoBlock(
                "FLIGHT DETAILS",
                new String[]{"Flight No.", "Route", "Date", "Departure", "Arrival"},
                new String[]{flightNo, source + " → " + destination, departDate, departTime, arrivalTime != null ? arrivalTime : "—"},
                labelFont, valueFont
            );
            infoTable.addCell(flightBlock);
            doc.add(infoTable);

            // ── PASSENGER LIST TABLE ───────────────────────────────
            if (passengers != null && !passengers.isEmpty()) {
                doc.add(Chunk.NEWLINE);
                Paragraph passengerTitle = new Paragraph("Passengers", sectionFont);
                passengerTitle.setSpacingBefore(4);
                doc.add(passengerTitle);
                doc.add(new LineSeparator(0.5f, 100, BORDER, Element.ALIGN_CENTER, -2));
                doc.add(Chunk.NEWLINE);

                PdfPTable pTable = new PdfPTable(5);
                pTable.setWidthPercentage(100);
                pTable.setWidths(new float[]{0.4f, 2f, 0.7f, 0.8f, 1f});

                String[] cols = {"#", "Full Name", "Age", "Gender", "Seat No."};
                for (String col : cols) {
                    PdfPCell th = new PdfPCell(new Phrase(col, headerFont));
                    th.setBackgroundColor(EMERALD);
                    th.setBorder(Rectangle.NO_BORDER);
                    th.setPadding(7);
                    pTable.addCell(th);
                }

                int idx = 1;
                for (PassengerRow p : passengers) {
                    boolean even = (idx % 2 == 0);
                    BaseColor rowBg = even ? LIGHT_BG : BaseColor.WHITE;
                    addTableCell(pTable, String.valueOf(idx++), valueFont, rowBg);
                    addTableCell(pTable, p.name != null ? p.name : "—", valueBold, rowBg);
                    addTableCell(pTable, p.age > 0 ? String.valueOf(p.age) : "—", valueFont, rowBg);
                    addTableCell(pTable, p.gender != null ? p.gender : "—", valueFont, rowBg);
                    addTableCell(pTable, p.seatNo != null ? p.seatNo : "—", valueFont, rowBg);
                }
                doc.add(pTable);
            }

            // ── FARE SUMMARY ───────────────────────────────────────
            doc.add(Chunk.NEWLINE);
            Paragraph fareTitle = new Paragraph("Fare Summary", sectionFont);
            fareTitle.setSpacingBefore(4);
            doc.add(fareTitle);
            doc.add(new LineSeparator(0.5f, 100, BORDER, Element.ALIGN_CENTER, -2));
            doc.add(Chunk.NEWLINE);

            PdfPTable fareTable = new PdfPTable(2);
            fareTable.setWidthPercentage(50);
            fareTable.setHorizontalAlignment(Element.ALIGN_RIGHT);

            addFareRow(fareTable, "Base Fare (" + numSeats + " seat" + (numSeats > 1 ? "s" : "") + ")",
                       "₹" + String.format("%,.2f", baseAmount), labelFont, valueFont, BaseColor.WHITE);
            addFareRow(fareTable, "GST (5%)",
                       "₹" + String.format("%,.2f", gstAmount), labelFont, valueFont, BaseColor.WHITE);
            addFareRow(fareTable, "Payment Method",
                       paymentMethod != null ? paymentMethod : "—", labelFont, valueFont, LIGHT_BG);

            // Total row (highlighted)
            PdfPCell totalLabel = new PdfPCell(new Phrase("TOTAL CHARGED", valueBold));
            totalLabel.setBackgroundColor(EMERALD_LIGHT);
            totalLabel.setBorder(Rectangle.BOX);
            totalLabel.setBorderColor(EMERALD);
            totalLabel.setPadding(9);
            fareTable.addCell(totalLabel);

            PdfPCell totalValue = new PdfPCell(new Phrase("₹" + String.format("%,.2f", totalAmount), amtFont));
            totalValue.setBackgroundColor(EMERALD_LIGHT);
            totalValue.setBorder(Rectangle.BOX);
            totalValue.setBorderColor(EMERALD);
            totalValue.setPadding(9);
            totalValue.setHorizontalAlignment(Element.ALIGN_RIGHT);
            fareTable.addCell(totalValue);

            doc.add(fareTable);

            // ── FOOTER ─────────────────────────────────────────────
            doc.add(Chunk.NEWLINE);
            doc.add(new LineSeparator(0.5f, 100, BORDER, Element.ALIGN_CENTER, 0));
            doc.add(Chunk.NEWLINE);
            Paragraph footer = new Paragraph(
                "Thank you for choosing AeroSphere. This is a computer-generated invoice and does not require a signature.\n" +
                "For support, contact us at support@aerosphere.in",
                smallMuted);
            footer.setAlignment(Element.ALIGN_CENTER);
            doc.add(footer);

            doc.close();

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Failed to generate PDF invoice for booking " + bookingId, e);
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // Data class for passenger rows
    // ─────────────────────────────────────────────────────────────────
    public static class PassengerRow {
        public String name;
        public int    age;
        public String gender;
        public String seatNo;

        public PassengerRow(String name, int age, String gender, String seatNo) {
            this.name   = name;
            this.age    = age;
            this.gender = gender;
            this.seatNo = seatNo;
        }
    }

    // ─────────────────────────────────────────────────────────────────
    // Helper methods
    // ─────────────────────────────────────────────────────────────────

    private static PdfPCell infoBlock(
            String title, String[] labels, String[] values,
            Font labelFont, Font valueFont) {

        PdfPCell cell = new PdfPCell();
        cell.setBorder(Rectangle.BOX);
        cell.setBorderColor(BORDER);
        cell.setPadding(12);
        cell.setBackgroundColor(BaseColor.WHITE);

        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, MUTED);
        Paragraph t = new Paragraph(title, titleFont);
        t.setSpacingAfter(6);
        cell.addElement(t);

        for (int i = 0; i < labels.length; i++) {
            Paragraph lbl = new Paragraph(labels[i], labelFont);
            lbl.setSpacingBefore(3);
            cell.addElement(lbl);
            Paragraph val = new Paragraph(values[i] != null ? values[i] : "—", valueFont);
            cell.addElement(val);
        }
        return cell;
    }

    private static void addTableCell(PdfPTable table, String text, Font font, BaseColor bg) {
        PdfPCell c = new PdfPCell(new Phrase(text, font));
        c.setBackgroundColor(bg);
        c.setBorderColor(BORDER);
        c.setPadding(6);
        table.addCell(c);
    }

    private static void addFareRow(
            PdfPTable table, String label, String value,
            Font labelFont, Font valueFont, BaseColor bg) {
        PdfPCell lc = new PdfPCell(new Phrase(label, labelFont));
        lc.setBackgroundColor(bg); lc.setBorderColor(BORDER); lc.setPadding(7);
        table.addCell(lc);
        PdfPCell vc = new PdfPCell(new Phrase(value, valueFont));
        vc.setBackgroundColor(bg); vc.setBorderColor(BORDER); vc.setPadding(7);
        vc.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(vc);
    }
}
