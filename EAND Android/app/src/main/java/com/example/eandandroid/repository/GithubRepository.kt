package com.example.eandandroid.repository

import com.example.eandandroid.model.GithubRepo
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for GitHub data operations
 */
interface GithubRepository {
    /**
     * Get the current selected repository
     */
    fun getSelectedRepository(): Flow<GithubRepo?>
    
    /**
     * Update the selected repository
     */
    fun updateSelectedRepository(repo: GithubRepo?)
}