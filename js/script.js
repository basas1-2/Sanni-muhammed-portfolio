/* ============================================
   PORTFOLIO SCRIPT
   Handles: theme toggle, mobile nav, typing
   animation, scroll effects, form handling.
   ============================================ */

document.addEventListener('DOMContentLoaded', () => {
  /* ---------- Theme Toggle ---------- */
  const themeToggle = document.getElementById('theme-toggle');
  const themeIcon = themeToggle.querySelector('i');

  // Check saved preference
  const savedTheme = localStorage.getItem('portfolio-theme');
  if (savedTheme === 'dark') {
    document.body.classList.add('dark');
    themeIcon.className = 'fas fa-moon';
  }

  themeToggle.addEventListener('click', () => {
    const isDark = document.body.classList.toggle('dark');
    themeIcon.className = isDark ? 'fas fa-moon' : 'fas fa-sun';
    localStorage.setItem('portfolio-theme', isDark ? 'dark' : 'light');
  });

  /* ---------- Mobile Navigation ---------- */
  const hamburger = document.getElementById('hamburger');
  const navLinks = document.getElementById('nav-links');

  hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    navLinks.classList.toggle('open');
  });

  // Close mobile menu when a link is clicked
  navLinks.querySelectorAll('a').forEach((link) => {
    link.addEventListener('click', () => {
      hamburger.classList.remove('open');
      navLinks.classList.remove('open');
    });
  });

  /* ---------- Navbar scroll effect ---------- */
  const navbar = document.getElementById('navbar');
  const scrollTopBtn = document.getElementById('scroll-top');
  const progressBar = document.getElementById('progress-bar');

  window.addEventListener('scroll', () => {
    const scrollTop = window.scrollY;
    const docHeight = document.documentElement.scrollHeight - window.innerHeight;

    // Navbar shadow
    navbar.classList.toggle('scrolled', scrollTop > 50);

    // Scroll to top button visibility
    scrollTopBtn.classList.toggle('show', scrollTop > 400);

    // Progress bar width
    const progress = (scrollTop / docHeight) * 100;
    progressBar.style.width = progress + '%';

    // Active nav link highlighting
    highlightActiveLink();
  });

  scrollTopBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  /* ---------- Active section highlighting ---------- */
  const sections = document.querySelectorAll('section[id]');
  const navAnchors = document.querySelectorAll('.nav-link');

  function highlightActiveLink() {
    const scrollPos = window.scrollY + 100;
    let currentId = '';

    sections.forEach((section) => {
      const offsetTop = section.offsetTop;
      const offsetBottom = offsetTop + section.offsetHeight;
      if (scrollPos >= offsetTop && scrollPos < offsetBottom) {
        currentId = section.id;
      }
    });

    if (!currentId && window.scrollY < 100) {
      currentId = 'hero';
    }

    navAnchors.forEach((link) => {
      link.classList.remove('active');
      if (link.getAttribute('href') === '#' + currentId) {
        link.classList.add('active');
      }
    });
  }

  /* ---------- Typing Animation ---------- */
  const typedElement = document.getElementById('typed-text');
  const roles = [
    'Full-Stack Software Developer',
    'Frontend Developer',
    'Backend Developer',
    'React Developer',
    'Node.js Developer',
    'LMS Builder',
  ];
  let roleIndex = 0;
  let charIndex = 0;
  let isDeleting = false;

  function typeEffect() {
    const currentRole = roles[roleIndex];

    if (!isDeleting) {
      typedElement.textContent = currentRole.substring(0, charIndex++);
    } else {
      typedElement.textContent = currentRole.substring(0, charIndex--);
    }

    let delay = isDeleting ? 40 : 90;

    if (!isDeleting && charIndex === currentRole.length + 1) {
      delay = 2000; // pause at full word
      isDeleting = true;
    } else if (isDeleting && charIndex === 0) {
      isDeleting = false;
      roleIndex = (roleIndex + 1) % roles.length;
      delay = 400;
    }

    setTimeout(typeEffect, delay);
  }

  typeEffect();

  /* ---------- Scroll Reveal Animations ---------- */
  const revealElements = document.querySelectorAll('.section-head, .skill-card, .about-card, .about-text, .timeline-card, .project-card, .service-card, .why-item, .career-box, .contact-item, .contact-form, .availability');

  const revealObserver = new IntersectionObserver(
    (entries, observer) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.1 }
  );

  revealElements.forEach((el) => {
    el.classList.add('reveal');
    revealObserver.observe(el);
  });

  /* ---------- Contact Form (mailto fallback) ---------- */
  const contactForm = document.getElementById('contact-form');

  contactForm.addEventListener('submit', (e) => {
    e.preventDefault();

    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const subject = document.getElementById('subject').value.trim();
    const message = document.getElementById('message').value.trim();

    if (!name || !email || !message) {
      alert('Please fill in your name, email, and message.');
      return;
    }

    const mailtoLink =
      'mailto:sannimuhammedarafat1@gmail.com' +
      '?subject=' + encodeURIComponent(subject || 'Portfolio Contact - ' + name) +
      '&body=' + encodeURIComponent('Name: ' + name + '\nEmail: ' + email + '\n\nMessage:\n' + message);

    window.location.href = mailtoLink;
    alert('Thank you for reaching out! Your email client should open to send your message.\n\nIf it did not open, email me directly at sannimuhammedarafat1@gmail.com');
  });

  /* ---------- Footer Year ---------- */
  document.getElementById('year').textContent = new Date().getFullYear();

  /* ---------- Lightbox (click image to view full size) ---------- */
  const lightbox = document.getElementById('lightbox');
  const lightboxImg = document.getElementById('lightbox-img');
  const lightboxCaption = document.getElementById('lightbox-caption');
  const lightboxClose = document.getElementById('lightbox-close');

  function openLightbox(img) {
    lightboxImg.src = img.src;
    lightboxImg.alt = img.alt || '';
    lightboxCaption.textContent = img.alt || '';
    lightbox.classList.add('open');
    lightbox.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }

  function closeLightbox() {
    lightbox.classList.remove('open');
    lightbox.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = '';
    lightboxImg.src = '';
  }

  document.querySelectorAll('.placeholder-img').forEach((img) => {
    img.addEventListener('click', (e) => {
      e.stopPropagation();
      openLightbox(img);
    });
  });

  lightboxClose.addEventListener('click', closeLightbox);

  // Click outside the image (on the dark backdrop) closes the lightbox
  lightbox.addEventListener('click', (e) => {
    if (e.target === lightbox) {
      closeLightbox();
    }
  });

  // Escape key closes the lightbox
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closeLightbox();
    }
  });
});
