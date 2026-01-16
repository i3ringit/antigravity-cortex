class DocsSidebar extends HTMLElement {
    connectedCallback() {
        // Prevent double-injection
        if (this.querySelector('.sidebar-header')) return;

        // Security: Validate base-path to prevent XSS/Traversal
        let basePath = this.getAttribute('base-path') || '.';
        if (!/^[\.\/]+$/.test(basePath)) {
            console.warn('Invalid base-path, falling back to current directory');
            basePath = '.';
        }

        // Use requestAnimationFrame to avoid layout thrashing during render
        requestAnimationFrame(() => {
            this.render(basePath);
            this.highlightActive();
        });
    }

    render(basePath) {
        // Capture page-specific content (TOC) before overwriting
        // We expect the user to put <div class="nav-section toc">...</div> inside <docs-sidebar>
        const tocSections = Array.from(this.querySelectorAll('.nav-section'));

        // Navigation Data
        // We construct HTML strings with safe interpolation of basePath
        const navStructure = `
      <div class="sidebar-header">
        <a href="${basePath}/index.html" class="nav-brand">
          <span class="logo-icon"><i class="fa-solid fa-layer-group"></i></span>
          <span class="logo-text">Cortex Docs</span>
        </a>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-section">
          <h3>Getting Started</h3>
          <ul>
            <li><a href="${basePath}/pages/getting-started.html">Installation</a></li>
          </ul>
        </div>
        <div class="nav-section">
          <h3>Reference</h3>
          <ul>
            <li><a href="${basePath}/pages/agents.html">Agent Skills (27)</a></li>
            <li><a href="${basePath}/pages/workflows.html">Workflows (19)</a></li>
            <li><a href="${basePath}/pages/skills.html">Tool Skills (12)</a></li>
            <li><a href="${basePath}/pages/mcp-servers.html">MCP Servers (2)</a></li>
          </ul>
        </div>
        <div class="nav-section">
          <h3>Resources</h3>
          <ul>
            <li><a href="${basePath}/pages/changelog.html">Changelog</a></li>
          </ul>
        </div>
        <!-- TOC Container -->
        <div id="toc-container"></div>
      </nav>
    `;

        // Render into Light DOM wrapped in an aside to match existing CSS selectors
        // We reuse the existing 'docs-sidebar' class for standard styling
        this.innerHTML = `
        <aside class="docs-sidebar">
            ${navStructure}
        </aside>
    `;

        // Re-inject TOC if it existed
        if (tocSections.length > 0) {
            const tocContainer = this.querySelector('#toc-container');
            if (tocContainer) {
                tocSections.forEach(section => tocContainer.appendChild(section));
            }
        }

        // Apply staggered animation to nav items
        const navItems = this.querySelectorAll('li');
        navItems.forEach((item, index) => {
            item.style.animation = `slideIn 0.3s ease forwards`;
            item.style.animationDelay = `${index * 50}ms`;
            item.style.opacity = '0';
        });
    }

    highlightActive() {
        const currentPath = window.location.pathname;
        const links = this.querySelectorAll('a');

        links.forEach(link => {
            // Simple heuristic: if the link href ends with the current filename
            if (link.href.includes(currentPath) && !link.hash) {
                link.classList.add('active');

                // Should also make the parent section visible (if we had collapsible sections)
            }
        });
    }
}

// Register the custom element
customElements.define('docs-sidebar', DocsSidebar);
