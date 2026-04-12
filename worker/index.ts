const MEDIA_HOST = "https://media.staging.elkana.dennisgilli.com";

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    // Redirect /img/* to the external media host
    if (url.pathname.startsWith("/img/")) {
      const target = `${MEDIA_HOST}${url.pathname}`;
      return Response.redirect(target, 301);
    }

    // For any other request that reached the worker, return 404.
    // In practice this shouldn't happen because run_worker_first
    // only routes /img/* through the worker.
    return new Response("Not Found", { status: 404 });
  },
};
