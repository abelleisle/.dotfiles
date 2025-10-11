-- Add custom yaml.docker-compose filetype
vim.filetype.add({
    pattern = {
        ["compose.*%.ya?ml"] = "yaml.docker-compose",
        ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    },
})
