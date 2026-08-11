<%@ Page Title="Blog" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="blog.aspx.cs" Inherits="Templet_Website.Blog" %>

<asp:Content ID="BlogHead" ContentPlaceHolderID="head" runat="server">
    <title>Blog - Student Freelancer</title>
    <style>
        /* ── Page Title Bar ── */
        .page-title {
            background: linear-gradient(135deg, #1e3a5f 0%, #163256 100%);
            padding: 40px 0 30px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
        }
        .page-title .breadcrumbs ol {
            display: flex;
            list-style: none;
            gap: 8px;
            padding: 0;
            margin: 0 0 8px;
            font-size: 13px;
        }
        .page-title .breadcrumbs ol li + li::before {
            content: "/";
            margin-right: 8px;
            color: rgba(255,255,255,0.4);
        }
        .page-title .breadcrumbs a { color: #47b2e4; text-decoration: none; }
        .page-title .breadcrumbs .current { color: rgba(255,255,255,0.6); }
        .page-title h1 { color: #fff; font-size: 2rem; font-weight: 700; margin: 0; }

        /* ── Blog Layout ── */
        .blog-layout { padding: 60px 0; background: #f4f6f9; }

        /* ── Article Cards ── */
        article.blog-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        article.blog-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.13);
        }
        .blog-card .post-img { overflow: hidden; height: 200px; }
        .blog-card .post-img img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .blog-card:hover .post-img img { transform: scale(1.06); }
        .blog-card .card-body { padding: 22px; flex: 1; display: flex; flex-direction: column; }

        .blog-card .category-badge {
            display: inline-block;
            background: rgba(71,178,228,0.12);
            color: #1e3a5f;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 3px 10px;
            border-radius: 50px;
            margin-bottom: 12px;
            border: 1px solid rgba(71,178,228,0.3);
        }

        .blog-card .title {
            font-size: 16px;
            font-weight: 700;
            line-height: 1.45;
            margin-bottom: 12px;
            flex: 1;
        }
        .blog-card .title a {
            color: #1e3a5f;
            text-decoration: none;
            transition: color 0.2s;
        }
        .blog-card .title a:hover { color: #47b2e4; }

        .blog-card .meta-top ul {
            list-style: none;
            padding: 0; margin: 0 0 14px;
            display: flex; gap: 14px;
            flex-wrap: wrap;
        }
        .blog-card .meta-top li {
            display: flex; align-items: center; gap: 5px;
            font-size: 12px; color: #888;
        }
        .blog-card .meta-top li i { color: #47b2e4; font-size: 13px; }
        .blog-card .meta-top a { color: #888; text-decoration: none; }

        .blog-card .content p {
            font-size: 14px; color: #666;
            line-height: 1.7; margin-bottom: 14px;
        }

        .read-more a {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; font-weight: 600;
            color: #1a73e8; text-decoration: none;
            transition: gap 0.2s;
        }
        .read-more a:hover { gap: 10px; color: #0d5cc5; }

        /* ── Sidebar ── */
        .sidebar { display: flex; flex-direction: column; gap: 24px; }

        .widget-item {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.06);
        }
        .widget-title {
            font-size: 16px; font-weight: 700; color: #1e3a5f;
            margin-bottom: 16px; padding-bottom: 10px;
            border-bottom: 2px solid #47b2e4;
        }

        /* Search widget */
        .search-widget form {
            display: flex; gap: 0;
            border: 1px solid #dde3ec;
            border-radius: 8px; overflow: hidden;
        }
        .search-widget input[type="text"] {
            flex: 1; border: none; outline: none;
            padding: 10px 14px; font-size: 14px; color: #444;
        }
        .search-widget button {
            background: #1a73e8; border: none;
            padding: 10px 16px; color: #fff;
            cursor: pointer; transition: background 0.2s;
        }
        .search-widget button:hover { background: #1558c0; }

        /* Recent Posts widget */
        .post-item {
            display: flex; gap: 12px; align-items: flex-start;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .post-item:last-child { border-bottom: none; padding-bottom: 0; }
        .post-item img {
            width: 60px; height: 60px;
            object-fit: cover; border-radius: 8px; flex-shrink: 0;
        }
        .post-item h4 { font-size: 13px; font-weight: 600; color: #1e3a5f; margin: 0 0 4px; }
        .post-item h4 a { color: inherit; text-decoration: none; }
        .post-item h4 a:hover { color: #47b2e4; }
        .post-item time { font-size: 11px; color: #aaa; }

        /* Categories widget */
        .categories-widget ul { list-style: none; padding: 0; margin: 0; }
        .categories-widget ul li {
            border-bottom: 1px solid #f0f0f0;
        }
        .categories-widget ul li:last-child { border-bottom: none; }
        .categories-widget ul li a {
            display: flex; justify-content: space-between;
            padding: 9px 0; font-size: 14px;
            color: #444; text-decoration: none;
            transition: color 0.2s;
        }
        .categories-widget ul li a:hover { color: #1a73e8; }
        .categories-widget ul li a span {
            background: #f0f4ff; color: #1a73e8;
            font-size: 12px; font-weight: 600;
            padding: 2px 8px; border-radius: 50px;
        }

        /* Tags widget */
        .tags-widget ul {
            list-style: none; padding: 0; margin: 0;
            display: flex; flex-wrap: wrap; gap: 8px;
        }
        .tags-widget ul li a {
            display: inline-block; padding: 5px 12px;
            background: #f4f6f9; color: #444;
            border: 1px solid #dde3ec;
            border-radius: 50px; font-size: 12px;
            text-decoration: none; transition: all 0.2s;
        }
        .tags-widget ul li a:hover {
            background: #1a73e8; color: #fff;
            border-color: #1a73e8;
        }

        /* ── Pagination ── */
        .pagination-wrap { padding: 30px 0; }
        .pagination-wrap ul {
            list-style: none; padding: 0; margin: 0;
            display: flex; justify-content: center; gap: 6px;
        }
        .pagination-wrap ul li a,
        .pagination-wrap ul li span {
            display: flex; align-items: center; justify-content: center;
            width: 38px; height: 38px; border-radius: 8px;
            border: 1px solid #dde3ec; color: #555;
            text-decoration: none; font-size: 14px;
            transition: all 0.2s;
        }
        .pagination-wrap ul li a:hover,
        .pagination-wrap ul li a.active {
            background: #1a73e8; color: #fff; border-color: #1a73e8;
        }

        /* ── Newsletter in footer area ── */
        .blog-newsletter {
            background: linear-gradient(135deg, #1e3a5f 0%, #163256 100%);
            padding: 50px 0;
            text-align: center;
            color: #fff;
        }
        .blog-newsletter h4 { font-size: 1.4rem; font-weight: 700; margin-bottom: 8px; }
        .blog-newsletter p { color: rgba(255,255,255,0.7); margin-bottom: 24px; }
        .newsletter-form-row {
            display: flex; justify-content: center; gap: 0;
            max-width: 460px; margin: 0 auto;
            border-radius: 50px; overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
        }
        .newsletter-form-row input[type="email"] {
            flex: 1; border: none; outline: none;
            padding: 13px 20px; font-size: 14px;
        }
        .newsletter-form-row button {
            background: #47b2e4; border: none;
            padding: 13px 24px; color: #fff;
            font-weight: 600; font-size: 14px;
            cursor: pointer; transition: background 0.2s;
            white-space: nowrap;
        }
        .newsletter-form-row button:hover { background: #1a73e8; }

        @media (max-width: 991px) {
            .sidebar { margin-top: 40px; }
        }
    </style>
</asp:Content>

<asp:Content ID="BlogBody" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">

    <!-- ── Page Title Bar ── -->
    <div class="page-title" data-aos="fade">
        <div class="container">
            <nav class="breadcrumbs">
                <ol>
                    <li><a href="WebForm1.aspx">Home</a></li>
                    <li class="current">Blog</li>
                </ol>
            </nav>
            <h1>Our Blog</h1>
        </div>
    </div>

    <!-- ── Main Blog Layout ── -->
    <div class="blog-layout">
        <div class="container">
            <div class="row">

                <!-- ── Left: Blog Posts ── -->
                <div class="col-lg-8">

                    <!-- ASP.NET Repeater — wire up to code-behind for DB-driven posts -->
                    <asp:Repeater ID="rptBlogPosts" runat="server" OnItemCommand="rptBlogPosts_ItemCommand">
                        <HeaderTemplate>
                            <div class="row gy-4" id="blog-posts-grid">
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="col-md-6" data-aos="fade-up">
                                <article class="blog-card">
                                    <div class="post-img">
                                        <img src='<%# Eval("ImageUrl") %>' alt='<%# Eval("Title") %>' class="img-fluid" />
                                    </div>
                                    <div class="card-body">
                                        <span class="category-badge"><%# Eval("Category") %></span>
                                        <h2 class="title">
                                            <a href='blog-details.aspx?id=<%# Eval("PostID") %>'><%# Eval("Title") %></a>
                                        </h2>
                                        <div class="meta-top">
                                            <ul>
                                                <li><i class="bi bi-person"></i> <a href="#"><%# Eval("AuthorName") %></a></li>
                                                <li><i class="bi bi-clock"></i> <time><%# ((DateTime)Eval("PublishedDate")).ToString("MMM d, yyyy") %></time></li>
                                                <li><i class="bi bi-chat-dots"></i> <%# Eval("CommentCount") %> Comments</li>
                                            </ul>
                                        </div>
                                        <div class="content">
                                            <p><%# Eval("Excerpt") %></p>
                                        </div>
                                        <div class="read-more">
                                            <a href='blog-details.aspx?id=<%# Eval("PostID") %>'>Read More <i class="bi bi-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </article>
                            </div>
                        </ItemTemplate>
                        <FooterTemplate>
                            </div>
                        </FooterTemplate>
                    </asp:Repeater>

                    <!-- Static fallback cards (shown when no DB data yet) -->
                    <asp:Panel ID="pnlStaticPosts" runat="server">
                        <div class="row gy-4">

                            <div class="col-md-6" data-aos="fade-up">
                                <article class="blog-card">
                                    <div class="post-img">
                                        <img src="assets/img/blog/blog-post-1.webp" alt="Blog Post 1" class="img-fluid">
                                    </div>
                                    <div class="card-body">
                                        <span class="category-badge">Design</span>
                                        <h2 class="title">
                                            <a href="blog-details.aspx">Dolorum optio tempore voluptas dignissimos cumque fuga qui quibusdam quia</a>
                                        </h2>
                                        <div class="meta-top">
                                            <ul>
                                                <li><i class="bi bi-person"></i> <a href="#">John Doe</a></li>
                                                <li><i class="bi bi-clock"></i> <time datetime="2025-01-01">Jan 1, 2025</time></li>
                                                <li><i class="bi bi-chat-dots"></i> 12 Comments</li>
                                            </ul>
                                        </div>
                                        <div class="content">
                                            <p>Similique neque nam consequuntur ad non maxime aliquam quas. Quibusdam animi praesentium. Aliquam et laboriosam eius aut nostrum quidem aliquid dicta.</p>
                                        </div>
                                        <div class="read-more">
                                            <a href="blog-details.aspx">Read More <i class="bi bi-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </article>
                            </div>

                            <div class="col-md-6" data-aos="fade-up" data-aos-delay="100">
                                <article class="blog-card">
                                    <div class="post-img">
                                        <img src="assets/img/blog/blog-post-2.webp" alt="Blog Post 2" class="img-fluid">
                                    </div>
                                    <div class="card-body">
                                        <span class="category-badge">Development</span>
                                        <h2 class="title">
                                            <a href="blog-details.aspx">Nisi magni odit consequatur autem nulla dolorem incidunt voluptate</a>
                                        </h2>
                                        <div class="meta-top">
                                            <ul>
                                                <li><i class="bi bi-person"></i> <a href="#">Jane Smith</a></li>
                                                <li><i class="bi bi-clock"></i> <time datetime="2025-02-15">Feb 15, 2025</time></li>
                                                <li><i class="bi bi-chat-dots"></i> 8 Comments</li>
                                            </ul>
                                        </div>
                                        <div class="content">
                                            <p>Incidunt voluptate sit temporibus aperiam. Quia vitae aut sint ullam quis illum voluptatum et. Quo libero rerum voluptatem pariatur nam ad impedit.</p>
                                        </div>
                                        <div class="read-more">
                                            <a href="blog-details.aspx">Read More <i class="bi bi-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </article>
                            </div>

                            <div class="col-md-6" data-aos="fade-up" data-aos-delay="150">
                                <article class="blog-card">
                                    <div class="post-img">
                                        <img src="assets/img/blog/blog-post-3.webp" alt="Blog Post 3" class="img-fluid">
                                    </div>
                                    <div class="card-body">
                                        <span class="category-badge">Education</span>
                                        <h2 class="title">
                                            <a href="blog-details.aspx">Possimus soluta ut id suscipit ea ut. In quo quia et soluta libero sit sint.</a>
                                        </h2>
                                        <div class="meta-top">
                                            <ul>
                                                <li><i class="bi bi-person"></i> <a href="#">Alex Kumar</a></li>
                                                <li><i class="bi bi-clock"></i> <time datetime="2025-03-10">Mar 10, 2025</time></li>
                                                <li><i class="bi bi-chat-dots"></i> 5 Comments</li>
                                            </ul>
                                        </div>
                                        <div class="content">
                                            <p>Aut iste neque ut illum qui perspiciatis similique recusandae non. Fugit autem dolorem labore omnis et eum temporibus fugiat voluptate.</p>
                                        </div>
                                        <div class="read-more">
                                            <a href="blog-details.aspx">Read More <i class="bi bi-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </article>
                            </div>

                            <div class="col-md-6" data-aos="fade-up" data-aos-delay="200">
                                <article class="blog-card">
                                    <div class="post-img">
                                        <img src="assets/img/blog/blog-post-4.webp" alt="Blog Post 4" class="img-fluid">
                                    </div>
                                    <div class="card-body">
                                        <span class="category-badge">Freelancing</span>
                                        <h2 class="title">
                                            <a href="blog-details.aspx">Non rem rerum nam cum quo minus. Dolor distinctio deleniti explicabo eius exercitationem.</a>
                                        </h2>
                                        <div class="meta-top">
                                            <ul>
                                                <li><i class="bi bi-person"></i> <a href="#">Maria Lee</a></li>
                                                <li><i class="bi bi-clock"></i> <time datetime="2025-04-22">Apr 22, 2025</time></li>
                                                <li><i class="bi bi-chat-dots"></i> 19 Comments</li>
                                            </ul>
                                        </div>
                                        <div class="content">
                                            <p>Aspernatur rerum perferendis et sint. Voluptates cupiditate voluptas atque quae. Rem veritatis rerum enim et autem. Saepe atque cum eligendi eaque.</p>
                                        </div>
                                        <div class="read-more">
                                            <a href="blog-details.aspx">Read More <i class="bi bi-arrow-right"></i></a>
                                        </div>
                                    </div>
                                </article>
                            </div>

                        </div><!-- /row -->
                    </asp:Panel>

                    <!-- ── Pagination ── -->
                    <div class="pagination-wrap" data-aos="fade-up">
                        <ul>
                            <li><a href="#" title="Previous"><i class="bi bi-chevron-left"></i></a></li>
                            <li><a href="#">1</a></li>
                            <li><a href="#" class="active">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">4</a></li>
                            <li><span>...</span></li>
                            <li><a href="#">10</a></li>
                            <li><a href="#" title="Next"><i class="bi bi-chevron-right"></i></a></li>
                        </ul>
                    </div>

                </div><!-- /col-lg-8 -->

                <!-- ── Right: Sidebar ── -->
                <div class="col-lg-4">
                    <div class="sidebar" data-aos="fade-up" data-aos-delay="200">

                        <!-- Search -->
                        <div class="widget-item search-widget">
                            <h3 class="widget-title">Search</h3>
                            <form action="blog.aspx" method="get">
                                <input type="text" name="q" id="blog-search" placeholder="Search posts…"
                                    value='<%= Request.QueryString["q"] ?? "" %>' />
                                <button type="submit" title="Search"><i class="bi bi-search"></i></button>
                            </form>
                        </div>

                        <!-- Recent Posts -->
                        <div class="widget-item recent-posts-widget">
                            <h3 class="widget-title">Recent Posts</h3>

                            <div class="post-item">
                                <img src="assets/img/blog/blog-post-square-1.webp" alt="Recent Post">
                                <div>
                                    <h4><a href="blog-details.aspx">Nihil blanditiis at in nihil autem</a></h4>
                                    <time datetime="2025-01-01">Jan 1, 2025</time>
                                </div>
                            </div>

                            <div class="post-item">
                                <img src="assets/img/blog/blog-post-square-2.webp" alt="Recent Post">
                                <div>
                                    <h4><a href="blog-details.aspx">Quidem autem et impedit</a></h4>
                                    <time datetime="2025-02-01">Feb 1, 2025</time>
                                </div>
                            </div>

                            <div class="post-item">
                                <img src="assets/img/blog/blog-post-square-3.webp" alt="Recent Post">
                                <div>
                                    <h4><a href="blog-details.aspx">Id quia et et ut maxime similique occaecati ut</a></h4>
                                    <time datetime="2025-03-01">Mar 1, 2025</time>
                                </div>
                            </div>

                            <div class="post-item">
                                <img src="assets/img/blog/blog-post-square-4.webp" alt="Recent Post">
                                <div>
                                    <h4><a href="blog-details.aspx">Laborum corporis quo dara net para</a></h4>
                                    <time datetime="2025-04-01">Apr 1, 2025</time>
                                </div>
                            </div>

                            <div class="post-item">
                                <img src="assets/img/blog/blog-post-square-5.webp" alt="Recent Post">
                                <div>
                                    <h4><a href="blog-details.aspx">Et dolores corrupti quae illo quod dolor</a></h4>
                                    <time datetime="2025-05-01">May 1, 2025</time>
                                </div>
                            </div>
                        </div>

                        <!-- Categories -->
                        <div class="widget-item categories-widget">
                            <h3 class="widget-title">Categories</h3>
                            <ul>
                                <li><a href="blog.aspx?cat=general">General <span>25</span></a></li>
                                <li><a href="blog.aspx?cat=lifestyle">Lifestyle <span>12</span></a></li>
                                <li><a href="blog.aspx?cat=travel">Travel <span>5</span></a></li>
                                <li><a href="blog.aspx?cat=design">Design <span>22</span></a></li>
                                <li><a href="blog.aspx?cat=creative">Creative <span>8</span></a></li>
                                <li><a href="blog.aspx?cat=education">Education <span>14</span></a></li>
                            </ul>
                        </div>

                        <!-- Tags -->
                        <div class="widget-item tags-widget">
                            <h3 class="widget-title">Tags</h3>
                            <ul>
                                <li><a href="blog.aspx?tag=app">App</a></li>
                                <li><a href="blog.aspx?tag=it">IT</a></li>
                                <li><a href="blog.aspx?tag=business">Business</a></li>
                                <li><a href="blog.aspx?tag=mac">Mac</a></li>
                                <li><a href="blog.aspx?tag=design">Design</a></li>
                                <li><a href="blog.aspx?tag=office">Office</a></li>
                                <li><a href="blog.aspx?tag=creative">Creative</a></li>
                                <li><a href="blog.aspx?tag=studio">Studio</a></li>
                                <li><a href="blog.aspx?tag=smart">Smart</a></li>
                                <li><a href="blog.aspx?tag=tips">Tips</a></li>
                                <li><a href="blog.aspx?tag=marketing">Marketing</a></li>
                            </ul>
                        </div>

                    </div><!-- /sidebar -->
                </div><!-- /col-lg-4 -->

            </div><!-- /row -->
        </div><!-- /container -->
    </div><!-- /blog-layout -->

    <!-- ── Newsletter Strip ── -->
    <div class="blog-newsletter" data-aos="fade-up">
        <div class="container">
            <h4>Join Our Newsletter</h4>
            <p>Subscribe to get the latest articles, tips, and freelancing advice straight to your inbox!</p>
            <div class="newsletter-form-row">
                <asp:TextBox ID="txtNewsletterEmail" runat="server" TextMode="Email"
                    placeholder="Enter your email address…" CssClass="newsletter-input" />
                <asp:Button ID="btnSubscribe" runat="server" Text="Subscribe"
                    OnClick="btnSubscribe_Click" CssClass="newsletter-btn" />
            </div>
            <asp:Label ID="lblSubscribeMsg" runat="server" CssClass="subscribe-msg" Visible="false" />
        </div>
    </div>

</asp:Content>
