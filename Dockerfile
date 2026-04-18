# ═══════════════════════════════════════════════════════════════
#  AeroSphere — Production Dockerfile
#  Multi-stage build: Maven build → Tomcat runtime
# ═══════════════════════════════════════════════════════════════

# ── Stage 1: Build with Maven ───────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-11 AS builder

WORKDIR /build

# Copy POM first (layer caching — deps don't re-download unless pom changes)
COPY pom.xml .
RUN mvn dependency:go-offline -B --no-transfer-progress

# Copy source and build WAR
COPY src ./src
COPY web ./web
RUN mvn clean package -DskipTests -B --no-transfer-progress

# ── Stage 2: Tomcat Runtime ─────────────────────────────────────
FROM tomcat:9.0-jdk11-temurin AS runtime

LABEL maintainer="AeroSphere Team"
LABEL description="AeroSphere Airline Booking System"

# Remove default Tomcat webapps (security hardening)
RUN rm -rf /usr/local/tomcat/webapps/*

# Remove default Tomcat examples and manager (security)
RUN rm -rf /usr/local/tomcat/webapps.dist

# Copy WAR as ROOT.war → context path becomes "/"
COPY --from=builder /build/target/app.war /usr/local/tomcat/webapps/ROOT.war

# Copy custom Tomcat server config (optional tuning)
COPY docker/tomcat/server.xml /usr/local/tomcat/conf/server.xml

# Create logs directory with proper permissions
RUN mkdir -p /usr/local/tomcat/logs && \
    chmod 755 /usr/local/tomcat/logs

# Expose Tomcat port
EXPOSE 8080

# Health check — waits up to 2 min for app to start, then checks /health
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
