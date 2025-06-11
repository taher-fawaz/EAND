package com.example.eandandroid.model

/**
 * Data class to hold GitHub repository information received from Flutter
 */
data class GithubRepo(
    val id: Int,
    val name: String,
    val fullName: String,
    val description: String?,
    val avatarUrl: String?,
    val htmlUrl: String?,
    val commits: List<Commit>? = null
)