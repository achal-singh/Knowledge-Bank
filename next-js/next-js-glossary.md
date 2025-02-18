# Next JS

### Key Commands

- Creating a new project: `npx create-next-app`.
- Running the dev server: `npm run dev`.
- Building the application: `npm run build`.
- Starting the application in production mode: `npm start`.

### Project Structure

1. **app** folder - The **app** folder or the **"app router"** is the container of the routing system, in NextJS routing is based on the filesystem.
2. **public** folder - It contains all the public assets of our project lik media files, images etc.

### Fundamentals

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

> Note: In NextJS all components inside the **_app_** folder are **_Server Components_** by default.

7. **Converting a Server Component to a Client Component**: To convert a server component to a client component, we can use the **'use client'** directive at the top of the Server Component file to convert it to Client Component. This directive also auto converts all the other server components that the current component depends on. By using this directive, we tell the NextJS compiler to include the component in the JavaScript bundle.

   > Note: Since we intend to follow a server-side-first approach for rendering components (for better SEO), we should use the **'use client'** directive sparingly.

**For example:**
Instead of converting the entire Product Card component to a client component, we can convert only the **Add to Cart** button to a client component. This way, the button will be rendered on the server, and the client-side JavaScript will be executed only when the button is clicked.

```tsx
import React from 'react'
import AddToCart from './AddToCart'

const ProductCard = () => {
  return (
    <div>
      <AddToCart />
    </div>
  )
}

export default ProductCard

/* AddToCart.tsx */
;('use client')
import React from 'react'

const AddToCart = () => {
  return (
    <div>
      <button
        onClick={() => {
          console.log('Added to Cart!')
        }}
      >
        Add to cart
      </button>
    </div>
  )
}

export default AddToCart
```

8. **Data Fetching**: In NextJS data fetching can be performed either on the **Server** or on the **Client** side. On client side we use hooks such as **useEffect** (to fetch data from the backend) and **useState** (to update state variables).

   A sample of data fetching on server side looks like this:

   ```tsx
   import React from 'react'

   interface User {
     id: number
     name: string
   }

   const UsersPage = async () => {
     const res = await fetch('https://jsonplaceholder.typicode.com/users')
     const users: User[] = await res.json()

     return (
       <>
         <h1>Users</h1>
         <ul>
           {users.map(user => (
             <li key={user.id}>{user.name}</li>
           ))}
         </ul>
       </>
     )
   }

   export default UsersPage
   ```

   > Note: It's recommended to fetch data on the server side for better SEO and performance.

9. **Caching**: In NextJS the response of an API called made from the backend is automatically stored in a file system based cache. This cache is used to serve the same response to subsequent requests. This is useful when the data fetched from the backend is static and doesn't change frequently.

   1. However, if the data changes frequently, we can disable caching by setting the **_cache_** property to **'no-store'** in the **fetch** function:

   ```tsx
   export async function getStaticProps() {
     const res = await fetch('https://jsonplaceholder.typicode.com/users', {
       cache: 'no-store'
     })
     const users = await res.json()
     // Rendering logic...
   }
   ```

   2. We can also set the **_revalidate_** property to **_true_** to revalidate the data every 10 seconds, (basically runs a backend cron every 10 seconds to fetch the latest data):

   ```tsx
   const res = await fetch('https://jsonplaceholder.typicode.com/users', {
     next: { revalidate: 10 }
   })
   ```

   > Note: The cache is only available with the fetch function and not with the axios or any other library.

10. **Rendering**: In NextJS, we can render components in two ways:

    ![rendering](assets/render.png)

    1. **Static Generation**: The HTML is generated (stored in the filesystem as a .html files, not part of the bundle) at build time and is reused on each request. This is useful for pages that don't change frequently.

    2. **Dynamic Rendering**: The HTML is generated on each request. This is useful for pages that change frequently.

    Example: We can simulate the two behaviors by enabling and disabling caching in the API request. With caching enabled, the data is fetched only once and reused on each request (Static). With caching disabled, the data is fetched on each request (Dynamic).

    ```tsx
    // Static (cache enabled by default)
    const res = await fetch('https://jsonplaceholder.typicode.com/users')

    // Dynamic (caching disabled)
    const res = await fetch('https://jsonplaceholder.typicode.com/users', {
      cache: 'no-store'
    })
    ```

### Styling

11. **Global Styling**: We can add global styles to our NextJS application by creating a **_global.css_** file. We can import the following base styling files of tailwind CSS library:

    ```css
    @import 'tailwindcss/base';
    @import 'tailwindcss/components';
    @import 'tailwindcss/utilities';
    ```

    > Note: The styling defined in the **global.css** file is applied to **_all_** the pages in the application. Any page or component specific styling should be defined in a separate CSS file.

12. **CSS Modules**:

    - In traditional CSS, if we define the same class in two different files, one will overwrite the other depending on the order in which these files are imported. **CSS modules** help us prevent this problem. A CSS module is a CSS file that is scoped to a page or component (defined with **_.module.css_** extension).

    - During the build process, Next.js uses a tool called **_PostCSS_** to transform our CSS class names and generate unique class names. This prevents clashes between different CSS classes across the application. We can configure PostCSS settings in the **_postcss.config.js_** file.

      ```css
      /* ProductCard.module.css */
      .card {
        padding: 1rem;
        border: 1px solid #ccc;
      }
      ```

      ```tsx
      // ProductCard.tsx
      import styles from './ProductCard.module.css';

      const ProductCard = () => {
        return (
          <div>
            <AddToCart />
          </div>
        );
      export default ProductCard;
      ```

      > Note: The import statement above can be thought of as an object and its properties are the class names defined in the CSS file. This is why, came case is used to define the class names in CSS. Optionally, JSX and CSS files for a component can also be put into separate folders. Ex: `components/ProductCard/ProductCard.tsx` and `components/ProductCard/ProductCard.module.css`.

      In place of the traditional CSS files as shown above, we may use CSS frameworks like Tailwind CSS.

13. **[Tailwind CSS](https://tailwindcss.com/)**: It's a **_utility-first CSS framework_** that provides a set of utility classes to style elements. Following are some Utility classes for space and text styling:

    - **Space Utility classes:**
      ![space-styles](assets/space-styles.png)
    - **Text Utility classes:**
      ![text-styles](assets/text-styles.png)

    We can use these utility classes and other pseudo-classes (like **:hover**) in our components like this:

    ```html
    <div className="p-5 my-5 bg-sky-400 text-white text-xl hover:bg-sky-500" />
    ```

14. **[DaisyUI](https://daisyui.com/)**: It's a component library that uses tailwind CSS under the hood. It provides a set of components that can be used in our application. It can be installed using: **`npm i -D daisyui@latest`**. To use it we must import the **`daisyui`** package in the **`tailwind.config.js`** file:

        ```JS
          {
            plugins: [require('daisyui')],
            // Other configurations...
            daisyui: {
              themes: ['winter']
            }
          }
        ```

    Then we can use Semantic class names in our application like this:

    ```html
    <table className="table table-bordered"></table>
    <button className="btn btn-primary"></button>
    ```

### Routing & Navigation

15. **Special Files**: NextJS provides special files that can be used to customize the behavior of the application. These files are:

    - **_page.tsx_** - To make a route publically accessible in NextJS router. (Only this file in the folder is accessible publically).

    - **_layout.tsx_**: To define common layouts for the pages.

    - **_loading.tsx_**: To show Loading UIs.

    - **_route.tsx_**: To create APIs.

    - **_not-found.tsx_**: To show custom errors.

    - **_error.tsx_**: To show general error pages.

    > Note: While defining re-usable components, place components in the components folder (app/components) if they are intended for use across multiple routes OR co-locate components within the specific route folder (e.g., app/users) if their usage is limited to that particular route.

16. **Dynamic Routes**: It's a route with a parameter. For example, a route like **/users/1** where **1** is the parameter.

- To create a dynamic route in NextJS, we create a folder with the name of the route and add a **[id].tsx** file (here "id" can be replaced with any other slug name in camel case). At file system level, it'll look like: **`users/[id]/page.tsx`**.
- In order to make a route **_accept varying number of parameters_**, we can prefix the slug name with **"..."** in the folder name. For example, **[...id].tsx**. This is called **[Catch-All Segments](https://nextjs.org/docs/pages/building-your-application/routing/dynamic-routes#catch-all-segments)**, to catch all subsequent segments in the URL.

- In order to make the **_number of params optional_**, we can use **"[]"** in the slug name. For example, **[[...id]].tsx**. By doing this, the route will accept 0 or more parameters.

  ```tsx
  import React from 'react'

  // if [id] is the slug
  interface Props {
    params: {
      id: number // id accepts only 1 parameter (Ex: /users/1)
    }
  }

  // if [...id] is the slug
  interface Props {
    params: {
      id: string[] // id is an array of strings since it accepts multiple parameters (Ex: /users/1/2/3)
    }
  }

  // in case of query string param
  interface Props {
    params: {
      id: string[] // id is an array of strings since it accepts multiple parameters (Ex: /users/1/2/3)
    }
    searchParams: {
      sampleQueryVar: string // query string param
    }
  }

  const UserDetailPage = ({
    params: { id },
    searchParams: { sampleQueryVar }
  }: Props) => {
    return <div>UserDetailPage {id}</div>
  }

  export default UserDetailPage
  ```

  > Note: NextJS automatically passes a `params` and `searchParams` objects to the component ([id]/page.tsx) with the dynamic route parameter ("id" in the above example) and query string param slug (sampleQueryVar in the above example) (`/users?sampleQueryVar=registered`) respectively.

17. **Layouts**: Layouts are used to define UIs that are shared among different pages. In NextJS, we can create a **_layout.tsx_** file in the **_app_** folder to define a common layout for all the pages. For example, the layout.tsx file in the root of **app** folder defines the **_common UI for all the pages_** in the application. A layout component should have children of type **ReactNode**.

    Example:

    ```jsx
    export default function RootLayout({
      children
    }: {
      children: React.ReactNode
    }) {
      return (
        <html data-theme="winter" lang="en">
          <body className={inter.className}>
            <NavBar />
            <main className="p-5">{children}</main>
          </body>
        </html>
      )
    }
    ```

18. **Navigation using the Link Component**: There are multiple advantages of using the `<Link>` component:

- Link only downloads the content of the target page and not the entire page.
- Link pre-fetches the content of the target page that are in the viewport.
- Caches the content of the target page for faster navigation. This client-side cache is temporary and lasts only for the current session, meaning it is cleared as soon as a full-page reload is performed.

19. **Programmatic Navigation**: We can navigate programmatically using the **useRouter** hook provided by NextJS. This gives us access to the **AppRouterInstance** object which has methods like **push**, **replace**, **back**, **forward**, **reload** etc.

    ```tsx
    import { useRouter } from 'next/navigation'

    const NewUserPage = () => {
      const router = useRouter()

      return (
        <button
          className="btn btn-primary"
          onClick={() => {
            // Push is used to go to a new page and save the current page in the history
            router.push('/users')
          }}
        >
          Create
        </button>
      )
    }

    export default NewUserPage
    ```

20. **Showing Loading UI**: In React 18, we get the `<Suspense>` Component which can be used to show a loading UI (aka `fallback UI`) while the data is being fetched.

    ```tsx
    const UsersPage = async ({ searchParams: { sortBy } }: Props) => {
      return (
        <>
          <h1>Users</h1>
          <Link href="/users/new" className="btn">
            New User
          </Link>
          <Suspense fallback={<p>Loading...</p>}>
            <UserTable sortOrder={sortBy} />
          </Suspense>
        </>
      );

    export default UsersPage;
    ```

    We can use the same suspense component to show a loading UI when switching between pages by adding it to the root layout:

    ```jsx
    export default function RootLayout({
      children
    }: {
      children: React.ReactNode
    }) {
      return (
        <html data-theme="winter" lang="en">
          <body className={inter.className}>
            <NavBar />
            <main className="p-5">
              <Suspense fallback={<p>Loading...</p>}>{children}</Suspense>
            </main>
          </body>
        </html>
      )
    }
    ```

    Alternatively, we can also define a **_`loading.tsx`_** file in the root of the app folder to define the UI of the loading screen between pages (home, users etc).
    Loading.tsx:

    ```tsx
    import React from 'react'
    const loading = () => {
      return <span className="loading loading-spinner loading-md"></span>
    }
    export default loading
    ```

    > Note: To simulate a loading screen, in the Chrome dev tools we can select the Suspense Component in the Components tab and toggle the stopwatch icon to Suspend the Suspense component.

21. **Not-Found Page**: We can use another special file called **`not-found.tsx`** to define the layout of a page to display when a resource is not found. Similar to other special files, we can define a global not-found file at the root of the app folder which will be displayed if no route specific not-found file is defined.

    Example when a user doesn't exist we can define a not-found file in `users/[id]` folder:

    ```tsx
    import React from 'react'
    const UserNotFoundPage = () => {
      return <div>This User doesn't exist.</div>
    }
    export default UserNotFoundPage
    ```

22. **Handling Unexpected Errors**: In special files we have global-error.tsx and error.tsx files to handle errors at the app level and route level respectively.

    Example of `error.tsx`:

    ```tsx
    'use client'
    import React from 'react'

    interface Props {
      error: Error // Error object passed (by NextJS)
      reset: () => void // Reset button to retry the errored route (by NextJS)
    }

    const ErrorPage = ({ error, reset }: Props) => {
      console.log('Error: ', error)
      return (
        <>
          <div>An unexpected error has occurred.</div>
          <button className="btn" onClick={() => reset()}>
            Retry
          </button>
        </>
      )
    }

    export default ErrorPage
    ```

### Building APIs

Similar to how we define pages in NextJS, we can define APIs by creating a folder with the name of the route and adding a route.tsx file for it, all under the **api** folder. (Ex: **`app/api/users/route.tsx`**).

23. **GET route**:

    ```tsx
    // GET route at /api/users/route.tsx
    import { NextRequest, NextResponse } from 'next/server'
    export function GET(request: NextRequest) {
      return NextResponse.json({ message: 'Hello, World!' })
    }

    // GET route with param
    interface Props {
      params: {
        id: number
      }
    }
    // GET route at /api/users/[id]/route.tsx
    export function GET(req: NextRequest, { params: { id } }: Props) {
      if (id > 10)
        return NextResponse.json({ error: 'User not found' }, { status: 404 })

      return NextResponse.json({ id, name: 'Joe' })
    }
    ```

    > Note: To prevent caching of the API response, we include the request object in the function params.

24. **POST route** (Creating a new resource):

    ```tsx
    // POST route at /api/users/route.tsx
    export async function POST(request: NextRequest) {
      const body = await request.json()
      if (!body.name)
        return NextResponse.json({ error: 'Invalid Name' }, { status: 400 })
      return NextResponse.json(
        { message: `Hello, ${body.name}!` },
        { status: 201 }
      )
    }
    ```

    > Note: We return a 201 status code to indicate that the resource has been created successfully.

    25. **PUT and DELETE routes** (Updating and Deleting an existing resource):

    ```tsx
    export async function PUT(req: NextRequest, { params: { id } }: Props) {
      const body = await req.json()
      if (!body.name)
        return NextResponse.json({ error: 'Invalid Name' }, { status: 400 })

      if (id > 10)
        return NextResponse.json({ error: 'User not found' }, { status: 404 })

      return NextResponse.json({ id, name: body.name })
    }

    export async function DELETE(req: NextRequest, { params: { id } }: Props) {
      if (id > 10)
        return NextResponse.json({ error: 'User not found' }, { status: 404 })

      return NextResponse.json({ message: 'User deleted' })
    }
    ```

    Adding validation of request body using **`zod`** library:

    ```ts
    // defined at app/api/users/schema.ts
    import { z } from 'zod'

    const schema = z.object({
      name: z.string().min(3)
    })

    export default schema

    // Can be imported in POST and PUT route logic like this;
    import schema from './schema'
    const validation = schema.safeParse(body)
    if (!validaton.success) {
      return NextResponse.json(validation.error.errors, { status: 400 })
    }
    ```

    ### Database Integration using Prisma

25. **Initialising Prisma**: Run **`npx prisma init`** to initialise Prisma in the project. This will create a **`prisma`** folder with a **`schema.prisma`** file and a **`.env`** file with **`DATABASE_URL`** variable.

- `npx prisma format`: Formats the `schema.prisma` file.
- `npx prisma migrate dev`: Creates a new migration (along with a `migrations` folder). Prisma automatically executes the given migration into the mentioned database.

27. **Prisma Client**: It's a client that can be used to interact with the database. In dev environment NextJS performs Fast Refresh for every change in the code. To prevent the creation of multiple Prisma clients, we can ensure that the client is created only once and reused across the application.

    ```ts
    import { PrismaClient } from '@prisma/client'
    const globalForPrisma = global as unknown as { prisma: PrismaClient }
    export const prisma = globalForPrisma.prisma || new PrismaClient()
    if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
    ```

### Authentication using NextAuth.JS

28. **[OAuth using Google](https://next-auth.js.org/providers/google)**: To enable OAuth using Google, we need to create a project in the **[Google Developer Console](https://console.developers.google.com/apis/credentials)** and enable the Google OAuth API. We can then create OAuth credentials and configure the OAuth consent screen. Once the OAuth credentials (Client ID and Secret) are created, we can use them in the NextAuth configuration.

    ```ts
    // app/auth/[...nextauth].ts
    import NextAuth from 'next-auth'
    import GoogleProvider from 'next-auth/providers/google'

    const handler = NextAuth({
      providers: [
        GoogleProvider({
          clientId: process.env.GOOGLE_CLIENT_ID!,
          clientSecret: process.env.GOOGLE_CLIENT_SECRET!
        })
      ]
    })

    export { handler as GET, handler as POST }
    ```

29. **Authentication Sessions**: Once a user logs in successfully NextAuth creates an Authentical Session for that user, by default the session is represented as a JSON Web Token (JWT). This token can be located in **`DevTools > Application Tab > Cookies (on the side panel)`**. This JWT is a base64 encoded JSON object that is used to authenticate the user with the user.

    The JWT created by NextAuth can be seen using the following script (**_only meant for dev environment!_**)

    ```ts
    // app/auth/token/route.ts
    import { getToken } from 'next-auth/jwt'
    import { NextRequest, NextResponse } from 'next/server'

    export async function GET(req: NextRequest) {
      const token = await getToken({ req, secret: process.env.JWT_SECRET! })
      return NextResponse.json(token)
    }
    ```

30. **Accessing Sessions on the Client**: Since client components allow for interactivity, we can create a wrapper around **next-auth's `SessionProvider`** component. The wrapper can look like this:

    ```ts
    'use client'

    import React, { ReactNode } from 'react'
    import { SessionProvider } from 'next-auth/react'

    const AuthProvider = ({ children }: { children: ReactNode }) => {
      return <SessionProvider>{children}</SessionProvider>
    }

    export default AuthProvider
    ```

    The wrapper above can be imported directly in the root layout like this:

    ```tsx
    export default function RootLayout({
      children
    }: {
      children: React.ReactNode
    }) {
      return (
        <html data-theme="winter" lang="en">
          <body className={inter.className}>
            <AuthProvider>
              <NavBar />
              <main className="p-5">{children}</main>
            </AuthProvider>
          </body>
        </html>
      )
    }
    ```

    The **`SessionProvider`** component provides a **`session`** object that contains the user's session information, the same is passed down to its children components using [**Prop Drilling by React**](https://react.dev/learn/passing-data-deeply-with-context). The session object can be accessed in any child component like this:

    ```tsx
    'use client'

    import { useSession } from 'next-auth/react'
    import Link from 'next/link'
    import React from 'react'

    const NavBar = () => {
      const { status, data: session } = useSession()

      return (
        <div className="flex bg-slate-200 p-5 space-x-5">
          <Link href="/" className="mr-5">
            Next.JS
          </Link>
          <Link href="/users" className="mr-5">
            Users
          </Link>
          {status === 'authenticated' && <div>{session.user!.name}</div>}
          {status === 'unauthenticated' && (
            <Link href="/api/auth/signin">Login</Link>
          )}
        </div>
      )
    }

    export default NavBar
    ```

31. **Accessing Auth Session on the Server**: We can use next-auth's **`getServerSession`** function to fetch a user's credentials by supplying the auth provider's credentials (as shown in #28) as the argument.

    ```tsx
    export default async function Home() {
      const session = await getServerSession(authOptions)
      return (
        <main>
          <h1>Hello {session && <span>{session.user!.name}</span>} </h1>
          <Link href="/users">Users</Link>
          <ProductCard />
        </main>
      )
    }
    ```

32. **Signing Out Users**: We can leverage the **`api/auth/signout`** exposed by next-auth to sign out users.

    ```tsx
    {
      status === 'authenticated' && (
        <div>
          {session.user!.name}
          {
            <Link href="/api/auth/signout" className="ml-3">
              Sign Out
            </Link>
          }
        </div>
      )
    }
    ```

    Once signed out, the **`next-auth.session-token`** is removed from the Cookies of the browser.

33. **Middleware**: A middleware can be configured in the Next JS application by creating a **`middleware.ts`** file and its logic looks like this:

    ```ts
    import { NextRequest, NextResponse } from 'next/server'

    export function middleware(req: NextRequest) {
      return NextResponse.redirect(new URL('/new-page', req.url))
    }

    export const config = {
      // ?: zero or one
      // +: one or more
      // *: zero or more
      matcher: ['/users/:id*']
    }
    ```

    In the above snippet, the middleware is configured to redirect the user to a new page when the user visits the **`/users/:id*`** route. The matcher can be configured to match multiple routes.

    However, while using `next-auth`, one can use its built-in middleware to protect routes. The middleware can be configured like this:

    ```ts
    export { default } from 'next-auth/middleware'

    export const config = {
      // ?: zero or one params
      // +: one or more params
      // *: zero or more params
      matcher: ['/users/:id*']
    }
    ```

34. **Database Adapters**: Database Adapters allow the NextJS serves as a layer of abstraction between your application logic and the underlying database.

    - The prisma adapter can be installed using" **`npm i @next-auth/prisma-adapter`**.

    - In order to automatically store the login data from Google's OAuth login we can simply copy paste [**the schema definition from Auth.js doc**](https://authjs.dev/getting-started/adapters/prisma?framework=next-js#naming-conventions).

    - In `/auth/[...nextauth]/route.tsx` we add **`adapter: PrismaAdapter(prisma)`** in the **authOptions**.

- After using DB adapters NextJS changes the session strategy to database from social-login/OAuth providers. To set the session strategy back to `'jwt'` (by social login), we set the session property in the **`authOptions`**:

  ```ts
  export const authOptions: NextAuthOptions = {
    adapter: PrismaAdapter(prisma),
    providers: [
      GoogleProvider({
        clientId: process.env.GOOGLE_CLIENT_ID!,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET!
      })
    ],
    session: {
      strategy: 'jwt' // or can be set to 'database'
    }
  }
  ```

  After setting this, the **`users`** table get populated with the name and email of the user and the **`accounts`** table stores the provider (google in this case) and jwt token details.

35. **Implementing Credential Login (Username/Password)**: We can provision email/username and password based authentication as well. To add this, the Credentials provider can be added to the authOptions [**as explained in the Auth.js doc**](https://authjs.dev/getting-started/providers/credentials?framework=next-js#configuration).

    The final implementation of `Credentials` and its **`authorize`** method looks like this:

    ```ts
    Credentials({
      credentials: {
        email: { label: 'Email', type: 'email', placeholder: 'Email' },
        password: { label: 'Password', type: 'password' }
      },
      async authorize(credentials, req) {
        if (!credentials?.email || !credentials.password) return null
        const user = await prisma.user.findUnique({
          where: { email: credentials.email }
        })
        if (!user) return null
        const passwordsMatch = await compare(
          credentials.password,
          user.hashedPassword!
        )
        return passwordsMatch ? user : null
      }
    }),
    ```

36. **Registering User**: We must add a register route to support the credential-based authorization of a user. The following route logic can be added to **`app/api/register/route.ts`**:

    ```ts
    import { z } from 'zod'
    import { hash } from 'bcrypt'
    import { prisma } from '@/prisma/client'
    import { NextRequest, NextResponse } from 'next/server'

    const schema = z.object({
      email: z.string().email(),
      password: z.string().min(5)
    })

    export async function POST(request: NextRequest) {
      const body = await request.json()
      const validation = schema.safeParse(body)
      if (!validation.success)
        return NextResponse.json(validation.error.errors, { status: 400 })

      const user = await prisma.user.findUnique({
        where: { email: body.email }
      })
      if (user)
        return NextResponse.json(
          { error: 'User already exists.' },
          { status: 400 }
        )

      const hashedPassword = await hash(body.password, 10)
      const newUser = await prisma.user.create({
        data: {
          email: body.email,
          hashedPassword
        }
      })
      return NextResponse.json({ email: newUser.email })
    }
    ```

    > Additional References: [**Implementing Custom Sign-In/Out pages**](https://authjs.dev/guides/pages/signin?framework=next-js)

### Sending Emails

37. **Setting up [React Email](https://react.email/docs/introduction)**: Create a separate folder named `emails` in the root of the applciation and create a `WelcomeTemplate.tsx` file and populate it with the following code:

    ```tsx
    import React from 'react'
    import {
      Html,
      Body,
      Container,
      Text,
      Link,
      Preview
    } from '@react-email/components'

    const WelcomeTemplate = ({ name }: { name: string }) => {
      return (
        <Html>
          <Preview>Welcome User!</Preview>
          <Body>
            <Container>
              <Text>Hello {name}!</Text>
              <Link href="https://Google.com">Google</Link>
            </Container>
          </Body>
        </Html>
      )
    }

    export default WelcomeTemplate
    ```

    > Note: On running the command: `email dev -p 3030` which launches the local development environment for React Email, where you can preview and test email templates on http://localhost:3030. In order to ignore files created by react-email, add `.react-email/` to `.gitignore`.

38. **Styling Emails**: The email can be styled using Tailwind classes, available within the react module.

    ```tsx
    import { Tailwind } from '@react-email/components'
    const WelcomeTemplate = ({ name }: { name: string }) => {
      return (
        <Html>
          <Preview>Welcome User!</Preview>
          <Tailwind>
            <Body className="bg-white">
              <Container>
                <Text className="font-bold text-2xl">Hello {name}!</Text>
                <Link href="https://Google.com">Google</Link>
              </Container>
            </Body>
          </Tailwind>
        </Html>
      )
    }
    ```

39. **Sending Emails using [Resend](https://react.email/docs/integrations/resend)**: After generating the API Key for resend. The following code can be called to send an email. In this we reference the `WelcomeTemplate` component and pass the `name` prop to it.

    ```ts
    import { Resend } from 'resend'
    const resend = new Resend(process.env.RESEND_API_KEY)
    import WelcomeTemplate from '@/emails/WelcomeTemplate'

    await resend.emails.send({
      from: 'sample@mydomain.com', // make sure you own this domain
      to: 'another@gmail.com',
      subject: 'Hello World',
      html: '<p>Congrats on sending your <strong>first email</strong>!</p>',
      react: <WelcomeTemplate name="Achal" />
    })
    ```
