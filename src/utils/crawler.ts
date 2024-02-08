import puppeteer from "puppeteer";

import { extract_from_html } from "./extracter";

export async function crawl(url: string, headless: boolean = true) {
  let article = {
    title: "",
    content: "",
    markdown: "",
    excerpt: "",
  };
  try {
    const browser = await puppeteer.launch({
      headless,
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });
    const [page] = await browser.pages();

    await page.goto(url, { waitUntil: "networkidle0" });

    const html = await page.content();

    article = await extract_from_html(html, url);

    await browser.close();
  } catch (err) {
    console.error(err);
  }

  return article;
}
