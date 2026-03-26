//! macOS SDK discovery via `xcrun`.
//!
//! Locates the active macOS SDK and queries its version, providing the
//! base paths needed for framework discovery and header parsing.

use std::path::{Path, PathBuf};
use std::process::Command;

use anyhow::{Context, Result};

/// Information about the active macOS SDK.
#[derive(Debug, Clone)]
pub struct SdkInfo {
    /// Absolute path to the SDK root (e.g., `/Applications/Xcode.app/.../MacOSX.sdk`).
    pub path: PathBuf,
    /// SDK version string (e.g., `"15.4"`).
    pub version: String,
}

/// Discover the active macOS SDK via `xcrun`.
pub fn discover_sdk() -> Result<SdkInfo> {
    let path = sdk_path()?;
    let version = sdk_version()?;
    Ok(SdkInfo { path, version })
}

/// Get the SDK root path via `xcrun --show-sdk-path`.
fn sdk_path() -> Result<PathBuf> {
    let output = Command::new("xcrun")
        .args(["--show-sdk-path"])
        .output()
        .context("failed to execute xcrun --show-sdk-path")?;

    if !output.status.success() {
        anyhow::bail!(
            "xcrun --show-sdk-path failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }

    let path = String::from_utf8(output.stdout)
        .context("xcrun output is not valid UTF-8")?
        .trim()
        .to_string();

    Ok(PathBuf::from(path))
}

/// Get the SDK version via `xcrun --show-sdk-version`.
fn sdk_version() -> Result<String> {
    let output = Command::new("xcrun")
        .args(["--show-sdk-version"])
        .output()
        .context("failed to execute xcrun --show-sdk-version")?;

    if !output.status.success() {
        anyhow::bail!(
            "xcrun --show-sdk-version failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }

    let version = String::from_utf8(output.stdout)
        .context("xcrun output is not valid UTF-8")?
        .trim()
        .to_string();

    Ok(version)
}

/// Discover available frameworks by scanning `{SDK}/System/Library/Frameworks/`.
///
/// Returns framework names (e.g., `"Foundation"`, `"AppKit"`) for directories
/// that contain an umbrella header matching the framework name.
pub fn discover_frameworks(sdk_path: &Path) -> Result<Vec<FrameworkInfo>> {
    let frameworks_dir = sdk_path.join("System/Library/Frameworks");
    if !frameworks_dir.exists() {
        anyhow::bail!(
            "frameworks directory not found: {}",
            frameworks_dir.display()
        );
    }

    let mut frameworks = Vec::new();

    for entry in std::fs::read_dir(&frameworks_dir)
        .with_context(|| format!("failed to read {}", frameworks_dir.display()))?
    {
        let entry = entry?;
        let path = entry.path();

        if !path.is_dir() {
            continue;
        }

        let dir_name = match path.file_name().and_then(|n| n.to_str()) {
            Some(name) => name.to_string(),
            None => continue,
        };

        // Framework directories end with .framework
        let framework_name = match dir_name.strip_suffix(".framework") {
            Some(name) => name.to_string(),
            None => continue,
        };

        // Check for umbrella header
        let umbrella_header = path.join("Headers").join(format!("{framework_name}.h"));
        if !umbrella_header.exists() {
            tracing::debug!(
                framework = %framework_name,
                "skipping framework: no umbrella header"
            );
            continue;
        }

        frameworks.push(FrameworkInfo {
            name: framework_name,
            umbrella_header,
            framework_dir: path,
        });
    }

    frameworks.sort_by(|a, b| a.name.cmp(&b.name));
    Ok(frameworks)
}

/// Information about a discovered framework.
#[derive(Debug, Clone)]
pub struct FrameworkInfo {
    /// Framework name (e.g., `"Foundation"`).
    pub name: String,
    /// Path to the umbrella header (e.g., `.../Foundation.framework/Headers/Foundation.h`).
    pub umbrella_header: PathBuf,
    /// Path to the framework directory.
    pub framework_dir: PathBuf,
}
