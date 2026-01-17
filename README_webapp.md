# Delta Pokemon Database Web Application

A Flask-based web frontend for browsing your Delta Pokemon database.

## Features

- **Browse all Pokemon** - View all Delta Pokemon with their types, abilities, and stats
- **Detailed Pokemon pages** - See complete stats, abilities with descriptions, and visual stat bars
- **Abilities database** - Browse all abilities with their descriptions
- **Search functionality** - Search by Pokemon name, type, or ability
- **Responsive design** - Works on desktop and mobile devices
- **Type-specific styling** - Color-coded type badges

## Setup Instructions

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Database Connection

Edit `app.py` and update the database configuration:

```python
DB_CONFIG = {
    'host': 'localhost',
    'database': 'your_database_name',  # Change this
    'user': 'your_mysql_username',     # Change this
    'password': 'your_mysql_password'  # Change this
}
```

### 3. Make sure your database is set up

Run your SQL schema if you haven't already:

```bash
mysql -u username -p --local-infile=1 database_name
```

```sql
source schema/create_tables_fixed.sql;
```

### 4. Run the Application

```bash
python app.py
```

The application will be available at: `http://localhost:5000`

## Pages

- **Home** (`/`) - Browse all Pokemon
- **Pokemon Detail** (`/pokemon/<id>`) - Detailed view of a single Pokemon
- **Abilities** (`/abilities`) - List all abilities
- **Search** (`/search?q=term`) - Search results

## File Structure

```
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── templates/            # HTML templates
│   ├── base.html         # Base template with navigation
│   ├── index.html        # Pokemon listing page
│   ├── pokemon_detail.html # Individual Pokemon page
│   ├── abilities.html    # Abilities listing
│   └── search.html       # Search results
└── static/              # Static files
    └── css/
        └── style.css     # Custom styles
```

## Customization

- **Styling**: Edit `static/css/style.css` to customize colors and layout
- **Database queries**: Modify the SQL queries in `app.py` to add new features
- **Templates**: Update HTML templates in `templates/` folder for layout changes

## Troubleshooting

- **Database connection errors**: Check your MySQL credentials in `app.py`
- **Missing data**: Ensure your database tables are populated
- **Port conflicts**: Change the port in `app.run(debug=True, port=5001)`
