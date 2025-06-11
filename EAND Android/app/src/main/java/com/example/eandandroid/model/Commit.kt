package com.example.eandandroid.model

/**
 * Data class to hold GitHub commit information received from Flutter
 */
data class Commit(
    val sha: String,
    val authorName: String,
    val message: String
)
