const express = require('express');
const db = require('../db/connection');
const router = express.Router();

// CREATE
router.post('/users', (req, res) => {
    const { name, email, age } = req.body;
    const query = 'INSERT INTO users (name, email, age) VALUES (?, ?, ?)';
    db.query(query, [name, email, age], (err, result) => {
        if (err) return res.status(500).send(err);
        res.status(201).send({ id: result.insertId, name, email, age });
    });
});

// READ ALL
router.get('/users', (req, res) => {
    db.query('SELECT * FROM users', (err, results) => {
        if (err) return res.status(500).send(err);
        res.status(200).send(results);
    });
});

// READ ONE
router.get('/users/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM users WHERE id = ?', [id], (err, results) => {
        if (err) return res.status(500).send(err);
        if (results.length === 0) return res.status(404).send({ message: 'User not found' });
        res.status(200).send(results[0]);
    });
});

// UPDATE
router.put('/users/:id', (req, res) => {
    const { id } = req.params;
    const { name, email, age } = req.body;
    const query = 'UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?';
    db.query(query, [name, email, age, id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.status(200).send({ message: 'User updated successfully' });
    });
});

// DELETE
router.delete('/users/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM users WHERE id = ?', [id], (err, result) => {
        if (err) return res.status(500).send(err);
        res.status(200).send({ message: 'User deleted successfully' });
    });
});

module.exports = router;