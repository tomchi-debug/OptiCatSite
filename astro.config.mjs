import { defineConfig } from 'astro/config';
import netlify from '@astrojs/netlify';

// https://astro.build/config
export default defineConfig({
  output: 'hybrid', // Hybrid allows both SSG and SSR
  adapter: netlify(),
});
