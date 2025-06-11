package com.example.eandandroid.ui.screens

import android.content.Context
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.eandandroid.model.GithubRepo
import com.example.eandandroid.ui.components.GithubHeader
import com.example.eandandroid.ui.components.RepoDetailCard
import com.example.eandandroid.ui.components.ShowReposButton
import com.example.eandandroid.viewmodel.GithubViewModel
import io.flutter.embedding.android.FlutterActivity

private const val FLUTTER_ENGINE_ID = "flutter_engine"

/**
 * Main screen for the GitHub repository viewer
 */
@Composable
fun GithubScreen(
    viewModel: GithubViewModel,
    context: Context
) {
    // Collect the selected repository from the ViewModel
    val selectedRepo = viewModel.selectedRepository.collectAsState().value
    val scrollState = rememberScrollState()

    Column(modifier = Modifier.padding(16.dp).verticalScroll(scrollState)) {
        // GitHub header
        GithubHeader()

        // Button to show repositories
        ShowReposButton(onClick = {
            // Launch Flutter activity
            val flutterIntent = FlutterActivity
                .withCachedEngine(FLUTTER_ENGINE_ID)
                .build(context)
            context.startActivity(flutterIntent)
        })

        // Show repo details if available
        selectedRepo?.let { repo ->
            Spacer(modifier = Modifier.height(16.dp))
            RepoDetailCard(repo = repo)
        }
    }
}