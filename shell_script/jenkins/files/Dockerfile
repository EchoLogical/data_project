# Use an OpenJDK base image
FROM openjdk:11-jdk-slim

# Set the Jenkins version you want to use
ENV JENKINS_VERSION=2.414.1

# Set where to install Jenkins and where the WAR file will be placed
ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_WAR=/usr/share/jenkins/jenkins.war

# Create Jenkins home directory
RUN mkdir -p $JENKINS_HOME

# Expose the default Jenkins port
EXPOSE 8080

# Copy the Jenkins WAR file to the appropriate location inside the container
COPY app/jenkins.war $JENKINS_WAR

# Jenkins home volume so data persists
VOLUME $JENKINS_HOME

# Run Jenkins when the container starts
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]

# Default Jenkins port
CMD ["--httpPort=8080"]