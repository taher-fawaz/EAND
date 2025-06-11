package com.example.eandandroid.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.example.eandandroid.model.GithubRepo
import com.example.eandandroid.repository.GithubRepository
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

/**
 * ViewModel for GitHub repository data
 */
class GithubViewModel(private val repository: GithubRepository) : ViewModel() {
    
    // StateFlow to expose the selected repository
    private val _selectedRepository = MutableStateFlow<GithubRepo?>(null)
    val selectedRepository: StateFlow<GithubRepo?> = _selectedRepository.asStateFlow()
    
    init {
        // Collect repository updates
        viewModelScope.launch {
            repository.getSelectedRepository().collect { repo ->
                _selectedRepository.value = repo
            }
        }
    }
    
    /**
     * Update the selected repository
     */
    fun updateSelectedRepository(repo: GithubRepo?) {
        repository.updateSelectedRepository(repo)
    }
    
    /**
     * Factory for creating GithubViewModel with dependencies
     */
    class Factory(private val repository: GithubRepository) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            if (modelClass.isAssignableFrom(GithubViewModel::class.java)) {
                return GithubViewModel(repository) as T
            }
            throw IllegalArgumentException("Unknown ViewModel class")
        }
    }
}