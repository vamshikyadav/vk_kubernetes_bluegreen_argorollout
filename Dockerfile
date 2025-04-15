FROM python:3.9-slim

# Install dependencies
RUN pip install streamlit

# Copy your app
COPY . /app
WORKDIR /app

# Run Streamlit with custom config via CMD
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.enableCORS=false", "--server.enableXsrfProtection=false", "--server.headless=true"]
