package com.example.eandandroid.repository

import com.example.eandandroid.model.GithubRepo
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow

/**
 * Implementation of GithubRepository that manages the selected repository data
 * received from Flutter
 */
class GithubRepositoryImpl : GithubRepository {
    
    // StateFlow to hold the current selected repository
    private val selectedRepositoryFlow = MutableStateFlow<GithubRepo?>(null)
    
    override fun getSelectedRepository(): Flow<GithubRepo?> = selectedRepositoryFlow
    
    override fun updateSelectedRepository(repo: GithubRepo?) {
        selectedRepositoryFlow.value = repo
    }
}