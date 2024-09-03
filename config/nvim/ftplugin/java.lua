local config = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
    root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
    java = {
        project = {
            sourcePaths = { "/Users/jasonjones/projects/personal/bazel-java-example/src/main/java" },
        },
    },
}

require("jdtls").start_or_attach(config)
