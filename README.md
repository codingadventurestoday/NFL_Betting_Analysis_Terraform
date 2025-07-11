# NFL_Betting_Analysis

This project provides a comprehensive system for evaluating the accuracy of DraftKings' NFL game predictions against actual game outcomes. It aims to identify patterns in prediction accuracy, especially concerning game competitiveness (close games, competitive games, blowouts), and to uncover potential strategic advantages for placing bets based on specific days.

## Project Overview
The core of this project involves collecting raw prediction data from DraftKings and official NFL game results. This data undergoes a robust cleaning process before being stored in a structured MySQL database. The database is hosted on a Google Cloud Platform (GCP) Virtual Machine instance, with its infrastructure managed entirely through Terraform and containerized using Docker for consistency and ease of deployment.

Once the data is stored, a sophisticated analysis pipeline evaluates DraftKings' predictive performance. This analysis specifically focuses on:

Close Games: How accurate are predictions for games decided by a small margin?

Competitive Games: Performance on games that remain tight throughout.

Blowouts: Accuracy in identifying games with a significant point differential.

Strategic Betting Days: Investigating if placing bets on certain days offers better odds or predictive insights for specific game types.

The insights derived from this analysis are then re-stored into the database, making them accessible for various applications. A FastAPI backend serves this analyzed data, providing a robust API for web page interactions. The user-facing component is built with Django, offering an intuitive interface to explore the evaluation results.

## Features
Automated Data Collection: Gathers DraftKings NFL prediction data and official NFL game outcomes.

Data Cleaning & Storage: Processes raw data, cleans it, and stores it in a MySQL database.

Infrastructure as Code (IaC): Leverages Terraform for automated provisioning and management of the GCP VM instance.

Containerization: Utilizes Docker for consistent deployment and environment management on the GCP VM.

In-depth Predictive Analysis: Analyzes DraftKings' model performance across different game types (close, competitive, blowouts).

Strategic Betting Insights: Identifies potential optimal days for placing bets based on game categories.

API-driven Data Access: FastAPI provides a high-performance API for accessing analyzed data.

Interactive Web Interface: A Django-powered frontend allows users to visualize and interact with the evaluation results.

## Technology Stack
Cloud Platform: Google Cloud Platform (GCP)

Infrastructure as Code: Terraform

Containerization: Docker

Database: MySQL

Backend API: FastAPI

Web Framework (Frontend/User Interface): Django

Programming Languages: Python

## Getting Started
A detailed guide on setting up and running the project will be provided in future documentation. Generally, the process will involve:

Cloning the repository.

Configuring GCP credentials for Terraform.

Deploying the GCP VM and Docker containers using Terraform.

Setting up the MySQL database.

Running the data collection, cleaning, and analysis scripts.

Launching the FastAPI and Django applications.

## Contribution
We welcome contributions from anyone interested in improving this project! Whether it's enhancing data collection, refining analysis algorithms, improving the user interface, or squashing bugs, your help is valuable.

If you're interested in contributing, please reach out to me via email: codingadventurestoday@gmail.com

## Contact
For any inquiries or collaboration opportunities, please feel free to contact:
codingadventurestoday@gmail.com
