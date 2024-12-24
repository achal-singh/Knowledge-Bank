# Next JS

### Project Structure

1. **app** folder - The **app** folder or the **"app router"** is the container of the routing system, in NextJS routing is based on the filesystem.
2. **public** folder - It contains all the public assets of our project lik media files, images etc.

### Routing & Navigation

3. Under the **app** folder we create all our routes by adding folders **_named same as our route names_** and within them a **"page".tsx/jsx** file. Naming the file **"page"** is important as it is part of the convention that NextJS uses.

4. To create a page for the **/users** route we can type the shortcut **"rafce"** which stands for **reactArrowFunctionExportComponent**. If we wish to any nested routes to the existing route, we simply add a new folder with the same name as the route and add a **"page"** file with all the component logic.

5. **Client-Side Navigation**: When adding a link to the **/users** page from the home page, using the anchor tag:

   ```tsx
   <a href="/users">Users</a>
   ```

   This triggers a **_full-page_** reload, causing the browser to reload **_all_** assets (e.g., fonts, HTML, CSS, JS and other assets) unnecessarily. Instead, we prefer client-side navigation to load only the page content while preserving shared assets like layouts and styles.

   > **FIX**: Instead, we use the **<Link\>** Component defined in NextJS, This enables **_Client-side Navigation_**, fetching only the assets of the /users page while preserving shared assets like layouts and styles.

6. **Rendering Techniques- CSR vs SSR**:
   ![CSR-vs-SSR](assets/csr-ssr.png)

**Client-side Rendering (CSR)**: Rendering of pages occurs on the client-side using JavaScript. The HTML sent to the browser contains minimal content, and the rest is rendered dynamically in the user's browser after the JavaScript is executed.

**Server-Side Rendering (SSR)**: Pages are pre-rendered on the server for every request, with the server sending fully rendered HTML to the browser. This ensures the content is available before the page is loaded.

> Note: While the minimal HTML and basic assets in CSR are also sent from the server (just like the fully rendered HTML in SSR), the key distinctions between CSR and SSR lie in two factors:

- What is being sent by the server?

  **CSR:** Minimal HTML and JavaScript assets needed for the client to dynamically render the page.

  **SSR:** Fully-rendered HTML with content already populated.

- Where does the rendering happen?

  **CSR:** Rendering happens in the **_browser after JavaScript is executed_**.

  **SSR:** Rendering happens on the **_server, and the fully-rendered HTML is sent to the browser_**.
