package com.example.eandandroid

import android.os.Bundle
import android.content.Context
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.ui.Modifier
import com.example.eandandroid.model.Commit
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import com.example.eandandroid.model.GithubRepo
import com.example.eandandroid.repository.GithubRepository
import com.example.eandandroid.repository.GithubRepositoryImpl
import com.example.eandandroid.ui.screens.GithubScreen
import com.example.eandandroid.ui.theme.EANDAndroidTheme
import com.example.eandandroid.viewmodel.GithubViewModel

private const val FLUTTER_ENGINE_ID = "flutter_engine"
private const val CHANNEL_NAME = "com.example.eand_flutter/channel"

/**
 * Main Activity for the Android application
 * Implements MVVM architecture with a clean separation of concerns
 */
class MainActivity : ComponentActivity() {
    // Flutter engine for communication with Flutter module
    private lateinit var flutterEngine: FlutterEngine
    
    // Repository for data operations
    private val repository: GithubRepository by lazy { GithubRepositoryImpl() }
    
    // ViewModel for managing UI state
    private val viewModel: GithubViewModel by viewModels { 
        GithubViewModel.Factory(repository) 
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        initializeFlutterEngine()
        setupMethodChannel()
        cacheFlutterEngine()
        setupUI()
    }
    
    /**
     * Initialize the Flutter engine
     */
    private fun initializeFlutterEngine() {
        flutterEngine = FlutterEngine(this)
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
    }
    
    /**
     * Set up method channel for communication with Flutter
     */
    private fun setupMethodChannel() {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "selectRepository" -> handleSelectRepository(call.arguments as Map<*, *>, result)
                "closeFlutterModule" -> handleCloseFlutterModule(result)
                else -> result.notImplemented()
            }
        }
    }
    
    /**
     * Handle the selectRepository method call from Flutter
     * Parses repository data and commit data from the Flutter module
     */
    private fun handleSelectRepository(repoData: Map<*, *>, result: MethodChannel.Result) {
        // Parse commits if available
        val commitsData = repoData["commits"] as? List<*>
        val commits = commitsData?.mapNotNull { commitMap ->
            if (commitMap is Map<*, *>) {
                Commit(
                    sha = commitMap["sha"] as String,
                    authorName = commitMap["authorName"] as String,
                    message = commitMap["message"] as String
                )
            } else null
        }
        
        // Create repository object with commits
        val repo = GithubRepo(
            id = (repoData["id"] as Number).toInt(),
            name = repoData["name"] as String,
            fullName = repoData["fullName"] as String,
            description = repoData["description"] as String?,
            avatarUrl = repoData["avatarUrl"] as String?,
            htmlUrl = repoData["htmlUrl"] as String?,
            commits = commits
        )
        
        viewModel.updateSelectedRepository(repo)
        result.success(true)
    }
    
    /**
     * Handle the closeFlutterModule method call from Flutter
     */
    private fun handleCloseFlutterModule(result: MethodChannel.Result) {
        this.finish()
        result.success(true)
    }
    
    /**
     * Cache the Flutter engine for reuse
     */
    private fun cacheFlutterEngine() {
        FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)
    }
    
    /**
     * Set up the UI using Jetpack Compose
     */
    private fun setupUI() {
        setContent {
            EANDAndroidTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    GithubScreen(
                        viewModel = viewModel,
                        context = this
                    )
                }
            }
        }
    }
}
