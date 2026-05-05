#!/bin/bash
# Create landing pages for The Clown and the Ice Castle + Bein and the World of Colors
# + enhanced RCP master page linking everything

set -e

BASE=/root/.openclaw/workspace

# Function to create a minimal but beautiful landing page
create_site() {
    local NAME="$1"
    local DOMAIN="$2"
    local TITLE="$3"
    local SUBTITLE="$4"
    local LOGLINE="$5"
    local DESC="$6"
    local GENRE="$7"
    local FORMAT="$8"
    local IMG_BG="$9"
    local COLOR="${10}"

    local DIR="$BASE/$DOMAIN-site"
    mkdir -p "$DIR/images" "$DIR/derivative-pitches"

    # Copy pitch PDFs for this IP
    local PREFIX="${NAME// /_}"
    PREFIX="${PREFIX//./}"
    cp "$BASE/sigillum-maximum-site/derivative-pitches/${PREFIX}_"*.pdf "$DIR/derivative-pitches/" 2>/dev/null || true
    cp "$BASE/sigillum-maximum-site/images/"* "$DIR/images/" 2>/dev/null || true

    cat > "$DIR/index.html" << HTMLEOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$TITLE — Eleanor Lian / RCP Productions</title>
    <meta name="description" content="$SUBTITLE — An original IP by Eleanor Lian, presented by Roberto Calvo Productions Ltd.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Lora:ital,wght@0,400;0,600;1,400&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Lora', serif;
            background: #0a0a0f;
            color: #e0dcd5;
            line-height: 1.7;
        }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #0a0a0f; }
        ::-webkit-scrollbar-thumb { background: #$COLOR; border-radius: 3px; }

        /* Nav */
        nav {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            background: rgba(10,10,15,0.92); backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255,255,255,0.05);
            padding: 0 24px; height: 60px;
            display: flex; align-items: center; justify-content: space-between;
        }
        nav .logo { font-family: 'Cinzel', serif; font-size: 0.9rem; color: #f0e8d8; text-decoration: none; letter-spacing: 0.12em; }
        nav .logo span { color: #d4a747; }
        .nav-links { display: flex; gap: 28px; list-style: none; }
        .nav-links a { color: #a09888; text-decoration: none; font-size: 0.8rem; font-family: 'Cinzel', serif; letter-spacing: 0.1em; text-transform: uppercase; transition: color 0.2s; }
        .nav-links a:hover { color: #f0e8d8; }
        .nav-toggle { display: none; background: none; border: none; color: #f0e8d8; font-size: 1.5rem; cursor: pointer; }

        /* Hero */
        .hero {
            min-height: 100vh;
            background: linear-gradient(135deg, #0a0a0f 0%, #0f0a08 30%, #0a0a12 60%, #0a0a0f 100%);
            display: flex; align-items: center; justify-content: center;
            text-align: center; padding: 100px 24px 60px;
            position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 30% 40%, rgba(0x$COLOR,0.03) 0%, transparent 60%);
        }
        .hero-content { position: relative; z-index: 1; max-width: 800px; }
        .hero-tag {
            font-family: 'Cinzel', serif; font-size: 0.7rem; letter-spacing: 0.2em; text-transform: uppercase;
            color: #d4a747; margin-bottom: 16px;
        }
        .hero-title {
            font-family: 'Cinzel', serif; font-size: 3rem; font-weight: 900;
            color: #f0e8d8; margin-bottom: 8px;
            background: linear-gradient(135deg, #f0e8d8 0%, #$COLOR 50%, #d4a747 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .hero-subtitle { font-size: 1.1rem; color: #a09888; margin-bottom: 20px; }
        .logline {
            font-size: 1rem; color: #c0b8a8; font-style: italic;
            max-width: 600px; margin: 0 auto 32px; line-height: 1.6;
        }
        .btn {
            display: inline-block; font-family: 'Cinzel', serif; font-size: 0.75rem;
            letter-spacing: 0.12em; text-transform: uppercase; padding: 12px 32px;
            border-radius: 4px; cursor: pointer; transition: all 0.2s; text-decoration: none;
        }
        .btn-primary { background: #d4a747; color: #0a0a0f; border: none; }
        .btn-primary:hover { background: #e0b857; transform: translateY(-1px); }
        .btn-outline { background: transparent; color: #d4a747; border: 1px solid #d4a747; }
        .btn-outline:hover { background: rgba(212,167,71,0.1); }

        /* Sections */
        .section { padding: 80px 24px; max-width: 1000px; margin: 0 auto; }
        .section-title {
            font-family: 'Cinzel', serif; font-size: 1.8rem; text-align: center;
            color: #f0e8d8; margin-bottom: 8px;
        }
        .section-title .gold { color: #d4a747; }
        .section-subtitle { text-align: center; color: #a09888; font-size: 0.9rem; margin-bottom: 48px; }

        /* Story */
        .story-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; align-items: center; }
        @media (max-width: 768px) { .story-grid { grid-template-columns: 1fr; } }
        .story-text p { color: #b0a898; margin-bottom: 16px; font-size: 0.95rem; }
        .story-text .highlight { color: #d4a747; font-weight: 600; }
        .story-image img { width: 100%; max-height: 400px; object-fit: cover; border-radius: 8px; border: 1px solid rgba(255,255,255,0.05); }

        /* Characters */
        .char-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; }
        .char-card {
            background: rgba(255,255,255,0.02); border: 1px solid rgba(255,255,255,0.05);
            border-radius: 8px; padding: 20px; text-align: center; transition: all 0.3s;
        }
        .char-card:hover { border-color: rgba(212,167,71,0.2); transform: translateY(-2px); }
        .char-card .avatar {
            width: 70px; height: 70px; border-radius: 50%; background: rgba(212,167,71,0.1);
            margin: 0 auto 12px; display: flex; align-items: center; justify-content: center;
            font-family: 'Cinzel', serif; font-size: 1.5rem; color: #d4a747;
        }
        .char-card h4 { font-family: 'Cinzel', serif; font-size: 0.9rem; color: #f0e8d8; margin-bottom: 4px; }
        .char-card p { font-size: 0.8rem; color: #807870; }

        /* For Producers */
        .for-producers {
            background: linear-gradient(180deg, #0a0a0f 0%, #0f0a08 50%, #0a0a0f 100%);
            border-top: 1px solid rgba(212,167,71,0.08);
            border-bottom: 1px solid rgba(212,167,71,0.08);
            padding: 80px 0;
        }
        .producers-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 24px;
            max-width: 1000px; margin: 0 auto;
        }
        @media (max-width: 768px) { .producers-grid { grid-template-columns: 1fr; } }
        .producer-card {
            background: rgba(255,255,255,0.02); border: 1px solid rgba(212,167,71,0.10);
            border-radius: 12px; padding: 28px; transition: border-color 0.3s, transform 0.3s;
        }
        .producer-card:hover { border-color: rgba(212,167,71,0.30); transform: translateY(-3px); }
        .producer-card .icon { font-size: 2rem; margin-bottom: 8px; display: block; }
        .producer-card h4 { font-family: 'Cinzel', serif; font-size: 1rem; color: #f0e8d8; margin-bottom: 4px; }
        .producer-card .badge {
            display: inline-block; font-family: 'Cinzel', serif; font-size: 0.6rem;
            letter-spacing: 0.12em; text-transform: uppercase; padding: 3px 10px;
            border-radius: 3px; margin-bottom: 10px;
            background: rgba(212,167,71,0.15); color: #d4a747; border: 1px solid rgba(212,167,71,0.25);
        }
        .producer-card p { color: #a09888; font-size: 0.85rem; line-height: 1.6; margin-bottom: 12px; }
        .btn-pitch {
            display: inline-block; font-family: 'Cinzel', serif; font-size: 0.65rem;
            letter-spacing: 0.1em; text-transform: uppercase; color: #d4a747;
            background: rgba(212,167,71,0.1); border: 1px solid rgba(212,167,71,0.25);
            padding: 6px 14px; border-radius: 4px; cursor: pointer; transition: all 0.2s; text-decoration: none;
        }
        .btn-pitch:hover { background: rgba(212,167,71,0.2); border-color: #d4a747; color: #f0e8d8; }
        .producer-cta { text-align: center; margin-top: 40px; }
        .producer-cta p { color: #a09888; font-size: 0.95rem; margin-bottom: 20px; }
        .producer-cta .btn + .btn { margin-left: 12px; }

        /* Contact */
        .contact-section { text-align: center; padding: 60px 24px; }
        .contact-section .logo-text {
            font-family: 'Cinzel', serif; font-size: 1.2rem; font-weight: 900;
            letter-spacing: 0.15em; color: #f0e8d8; margin-bottom: 8px;
        }
        .contact-section .logo-text span { color: #d4a747; }
        .contact-section p { color: #a09888; font-size: 0.85rem; margin-bottom: 16px; }
        .contact-link { color: #d4a747; border-bottom: 1px solid rgba(212,167,71,0.3); text-decoration: none; transition: border-color 0.3s; }
        .contact-link:hover { border-color: #d4a747; }

        footer { text-align: center; padding: 24px; color: #605850; font-size: 0.75rem; border-top: 1px solid rgba(255,255,255,0.04); }

        @media (max-width: 480px) {
            .hero-title { font-size: 2rem; }
            .nav-links { display: none; position: absolute; top: 60px; left: 0; right: 0; background: rgba(10,10,15,0.98); flex-direction: column; padding: 24px; gap: 16px; border-bottom: 1px solid rgba(212,167,71,0.15); }
            .nav-links.active { display: flex; }
            .nav-toggle { display: block; }
            .producers-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav>
    <a href="#" class="logo">RCP <span>Productions</span></a>
    <button class="nav-toggle" onclick="document.querySelector('.nav-links').classList.toggle('active')">☰</button>
    <ul class="nav-links">
        <li><a href="#story">Story</a></li>
        <li><a href="#characters">Characters</a></li>
        <li><a href="#producers">For Producers</a></li>
        <li><a href="#contact">Contact</a></li>
    </ul>
</nav>

<section class="hero">
    <div class="hero-content">
        <div class="hero-tag">$GENRE</div>
        <h1 class="hero-title">$TITLE</h1>
        <p class="hero-subtitle">$SUBTITLE</p>
        <p class="logline">"$LOGLINE"</p>
        <a href="#producers" class="btn btn-primary">For Producers</a>
        <a href="#story" class="btn btn-outline" style="margin-left:12px;">Discover the Story</a>
    </div>
</section>

<section class="section" id="story">
    <h2 class="section-title">The <span class="gold">Story</span></h2>
    <p class="section-subtitle">$FORMAT</p>
    <div class="story-grid">
        <div class="story-text">
            $DESC
        </div>
        <div class="story-image">
            <div style="background:rgba(255,255,255,0.02);border-radius:8px;padding:60px 20px;text-align:center;border:1px solid rgba(255,255,255,0.05);">
                <span style="font-size:3rem;">📖</span>
                <p style="color:#605850;font-size:0.85rem;margin-top:12px;">Artwork coming soon</p>
            </div>
        </div>
    </div>
</section>

<section id="characters" style="background:rgba(255,255,255,0.01);padding:80px 24px;">
    <div class="section" style="padding:0;max-width:1000px;margin:0 auto;">
        <h2 class="section-title">The <span class="gold">Characters</span></h2>
        <p class="section-subtitle">Meet the souls who inhabit this world</p>
        <div class="char-grid">
            <div class="char-card"><div class="avatar">?</div><h4>Protagonist</h4><p>Our hero</p></div>
            <div class="char-card"><div class="avatar">?</div><h4>Companion</h4><p>Loyal ally</p></div>
            <div class="char-card"><div class="avatar">?</div><h4>Guide</h4><p>Mysterious aide</p></div>
            <div class="char-card"><div class="avatar">?</div><h4>Friend</h4><p>Trusted support</p></div>
        </div>
    </div>
</section>

<!-- ==================== FOR PRODUCERS ==================== -->
<section class="for-producers" id="producers">
    <div class="container" style="max-width:1100px;margin:0 auto;padding:0 24px;">
        <h2 class="section-title">For <span class="gold">Producers</span></h2>
        <p class="section-subtitle" style="margin-bottom:40px;">A complete IP ready for development across multiple formats</p>

        <div class="producers-grid">
            <div class="producer-card">
                <span class="icon">🎥</span>
                <h4>Film Adaptation</h4>
                <div class="badge">Feature Film</div>
                <p>Live-action or animation. Complete manuscript + character designs ready for screen adaptation.</p>
                <a href="#" class="btn-pitch" onclick="alert('Pitch coming soon');return false;">Download Pitch (PDF)</a>
            </div>
            <div class="producer-card">
                <span class="icon">📺</span>
                <h4>Series</h4>
                <div class="badge">Limited / TV Series</div>
                <p>Built for episodic storytelling. Each chapter translates naturally to screen episodes.</p>
                <a href="#" class="btn-pitch" onclick="alert('Pitch coming soon');return false;">Download Pitch (PDF)</a>
            </div>
        </div>

        <div class="producer-cta">
            <p>Interested in licensing, co-production, or adaptation rights?</p>
            <a href="mailto:info@robertocalvoproductions.com" class="btn btn-primary">Contact RCP</a>
        </div>
    </div>
</section>

<section class="contact-section" id="contact">
    <div class="logo-text">ROBERTO CALVO <span>PRODUCTIONS</span> LTD</div>
    <p>Publishing · Production · Distribution<br>London, United Kingdom</p>
    <p>
        <a href="https://www.robertocalvoproductions.com" class="contact-link" target="_blank">robertocalvoproductions.com</a><br>
        <a href="mailto:info@robertocalvoproductions.com" class="contact-link">info@robertocalvoproductions.com</a>
    </p>
</section>

<footer>
    <p>&copy; 2026 Eleanor Lian (Eleonora Baliani) / RCP Productions Ltd. All rights reserved.</p>
    <p>Presented by <a href="https://www.robertocalvoproductions.com" style="color:#a09888;text-decoration:none;">Roberto Calvo Productions Ltd</a></p>
</footer>

<script>
    document.querySelectorAll('.nav-links a').forEach(a => {
        a.addEventListener('click', () => document.querySelector('.nav-links').classList.remove('active'));
    });
    document.querySelectorAll('a[href^="#"]').forEach(a => {
        a.addEventListener('click', e => {
            e.preventDefault();
            const target = document.querySelector(a.getAttribute('href'));
            if (target) target.scrollIntoView({ behavior: 'smooth' });
        });
    });
</script>
</body>
</html>
HTMLEOF

    # Create vercel.json
    cat > "$DIR/vercel.json" << VEOF
{
    "name": "$DOMAIN-site",
    "version": 2,
    "builds": [
        { "src": "**/*", "use": "@vercel/static" }
    ],
    "routes": [
        { "src": "/", "dest": "/index.html" },
        { "src": "/(.*)", "dest": "/$1" }
    ],
    "trailingSlash": false
}
VEOF

    echo "✅ Created $DOMAIN-site/"
}

# ===================
# CREATE THE CLOWN AND THE ICE CASTLE SITE
# ===================
CLOWN_DESC="
<p>Thalìa and George discover a mysterious ice castle that appears only under the full moon. Inside, a trickster clown guides them through frozen halls where every room reveals a buried memory, a forgotten kingdom, and a choice that will change everything.</p>
<p><span class='highlight'>A haunting tale</span> where the boundary between reality and nightmare dissolves — and the truth about ourselves lies frozen at the heart of the labyrinth.</p>
"

create_site \
    "Clown_Ice_Castle" \
    "clown-and-ice-castle" \
    "The Clown and the Ice Castle" \
    "A Dark Fantasy Tale" \
    "A mysterious clown, an enchanted castle — and the secrets frozen within." \
    "$CLOWN_DESC" \
    "Dark Fantasy / Mystery" \
    "Novel · 85,000 words · 35 chapters" \
    "none" \
    "80b0e0"

# ===================
# CREATE BEIN AND THE WORLD OF COLORS SITE
# ===================
BEIN_DESC="
<p>Bein sees the world differently — every emotion around him is a visible color. Joy is gold. Sadness is blue. Fear is grey. When a crisis drains all color from his world, he must journey through the Land of Faded Hues to find the Source of All Colors.</p>
<p><span class='highlight'>An emotional fantasy</span> that teaches children that all feelings are valid — and that the most beautiful spectrum comes from embracing them all.</p>
"

create_site \
    "Bein_World_of_Colors" \
    "bein-and-world-of-colors" \
    "Bein and the World of the Colors" \
    "An Emotional Fantasy" \
    "Every emotion has a color. Every color can heal." \
    "$BEIN_DESC" \
    "Emotional Fantasy / Children's" \
    "Novel · Illustrated · Full manuscript complete" \
    "none" \
    "64c8d0"

echo ""
echo "=========================================="
echo "✅ All landing pages created!"
echo ""
echo "Sites created:"
echo "  sigillummaximum.com → /root/.../sigillum-maximum-site/"
echo "  clown-and-ice-castle.vercel.app → /root/.../clown-and-ice-castle-site/"
echo "  bein-and-world-of-colors.vercel.app → /root/.../bein-and-world-of-colors-site/"
echo ""
echo "Pitch PDFs total:"
ls -la "$BASE/sigillum-maximum-site/derivative-pitches/"*.pdf 2>/dev/null | wc -l
echo "Note: Clown and Bein placeholder pitches need manual linking."
echo "=========================================="
