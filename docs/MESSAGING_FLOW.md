## Messaging Experience Plan

This document maps the current messaging flow and the targeted UX for each role so that buyers, sellers, and admins all understand where conversations live and what context they see.

### Buyer flow
- Entry point: listing detail modal ➜ “Message seller” CTA.
- Frontend calls `GET /marketplace/listings/:id` to confirm seller, then `POST /messages` with `recipientId`, `content`, and `listingId`.
- After sending, buyers are redirected/encouraged to view `/messages`, which now surfaces the conversation plus a contextual listing card (title, price, location, status).
- Buyers can see which conversations originated from listings via badges in the thread list, and each thread highlights the relevant listing metadata before the chat log so they know which item they were discussing.

### Seller flow
- Sellers use the same `/messages` workspace; conversations that reference one of their listings show the listing badge in the sidebar so they can prioritize buyer questions.
- Opening the thread loads all messages plus the listing card so sellers can quickly confirm price, availability, and jump back to the listing management page if they need to edit or mark it as sold.
- Real-time updates (Socket.IO) continue to stream in, and when a buyer mentions a listing the UI automatically attaches that listing context if it is not already cached.

### Admin visibility
- Admins currently moderate listings/events and are not part of private conversations, but they rely on signals that messaging is active.
- With the listing badge surfaced in the admin-facing Marketplace moderation table, it is easy to confirm that buyer interest exists. (Future work could include an aggregated “messages sent per listing” metric in the admin dashboard if moderation workflows require deeper insight.)
- To investigate abuse, admins would still query the backend directly; exposing private conversations in the UI is out of scope today to preserve member privacy.

### Backend alignment
- `POST /messages` already stores `listingId`. We now expose `lastListingId` + `hasListing` in `GET /messages` so the UI can differentiate listing-specific conversations.
- Sellers/buyers share the exact same `/messages` UI; the differentiator is simply which conversations display listing context, ensuring no extra dashboard is required.
