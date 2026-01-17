from flask import Flask, render_template, request, jsonify
import mysql.connector
from mysql.connector import Error
import os

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'database': 'delta_pokemon_db',  # Change this to your database name
    'user': 'your_username',        # Change this to your MySQL username
    'password': 'your_password'     # Change this to your MySQL password
}

def get_db_connection():
    """Create database connection"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

@app.route('/')
def index():
    """Main page showing all Pokemon"""
    connection = get_db_connection()
    if not connection:
        return "Database connection failed", 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT 
                p.id,
                p.name,
                p.type1,
                p.type2,
                a1.name as ability1,
                a2.name as ability2,
                a3.name as hiddenability,
                p.hp,
                p.attack,
                p.defence,
                p.specialattack,
                p.specialdefence,
                p.speed,
                p.bst
            FROM delta_pokemon_list p
            JOIN ability_list a1 ON p.ability1_id = a1.id
            LEFT JOIN ability_list a2 ON p.ability2_id = a2.id
            LEFT JOIN ability_list a3 ON p.hiddenability_id = a3.id
            ORDER BY p.name
        """)
        pokemon = cursor.fetchall()
        cursor.close()
        connection.close()
        
        return render_template('index.html', pokemon=pokemon)
    except Error as e:
        return f"Database error: {e}", 500

@app.route('/pokemon/<int:pokemon_id>')
def pokemon_detail(pokemon_id):
    """Detailed view of a single Pokemon"""
    connection = get_db_connection()
    if not connection:
        return "Database connection failed", 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("""
            SELECT 
                p.id,
                p.name,
                p.type1,
                p.type2,
                a1.name as ability1,
                a1.description as ability1_desc,
                a2.name as ability2,
                a2.description as ability2_desc,
                a3.name as hiddenability,
                a3.description as hiddenability_desc,
                p.hp,
                p.attack,
                p.defence,
                p.specialattack,
                p.specialdefence,
                p.speed,
                p.bst
            FROM delta_pokemon_list p
            JOIN ability_list a1 ON p.ability1_id = a1.id
            LEFT JOIN ability_list a2 ON p.ability2_id = a2.id
            LEFT JOIN ability_list a3 ON p.hiddenability_id = a3.id
            WHERE p.id = %s
        """, (pokemon_id,))
        pokemon = cursor.fetchone()
        cursor.close()
        connection.close()
        
        if not pokemon:
            return "Pokemon not found", 404
            
        return render_template('pokemon_detail.html', pokemon=pokemon)
    except Error as e:
        return f"Database error: {e}", 500

@app.route('/abilities')
def abilities():
    """List all abilities"""
    connection = get_db_connection()
    if not connection:
        return "Database connection failed", 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM ability_list ORDER BY name")
        abilities = cursor.fetchall()
        cursor.close()
        connection.close()
        
        return render_template('abilities.html', abilities=abilities)
    except Error as e:
        return f"Database error: {e}", 500

@app.route('/search')
def search():
    """Search Pokemon by name, type, or ability"""
    query = request.args.get('q', '').strip()
    if not query:
        return render_template('search.html', pokemon=[], query='')
    
    connection = get_db_connection()
    if not connection:
        return "Database connection failed", 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        search_query = f"%{query}%"
        cursor.execute("""
            SELECT 
                p.id,
                p.name,
                p.type1,
                p.type2,
                a1.name as ability1,
                a2.name as ability2,
                a3.name as hiddenability,
                p.hp,
                p.attack,
                p.defence,
                p.specialattack,
                p.specialdefence,
                p.speed,
                p.bst
            FROM delta_pokemon_list p
            JOIN ability_list a1 ON p.ability1_id = a1.id
            LEFT JOIN ability_list a2 ON p.ability2_id = a2.id
            LEFT JOIN ability_list a3 ON p.hiddenability_id = a3.id
            WHERE p.name LIKE %s 
               OR p.type1 LIKE %s 
               OR p.type2 LIKE %s
               OR a1.name LIKE %s
               OR a2.name LIKE %s
               OR a3.name LIKE %s
            ORDER BY p.name
        """, (search_query, search_query, search_query, search_query, search_query, search_query))
        pokemon = cursor.fetchall()
        cursor.close()
        connection.close()
        
        return render_template('search.html', pokemon=pokemon, query=query)
    except Error as e:
        return f"Database error: {e}", 500

if __name__ == '__main__':
    app.run(debug=True)