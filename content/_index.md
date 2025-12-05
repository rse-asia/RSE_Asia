---
# Leave the homepage title empty to use the site title
title:
date: 2022-10-24
type: landing

sections:
  - block: hero
    content:
      title: |
        RSE Asia Association
      image:
        filename: RSE_ASIA.png
      text: |
        <br>
        
        The Research Software Engineering Asia Association (RSE Asia) is volunteer run community with the mission to promote and build the Research Software Engineering community and profession in the Asian region while also fostering global collaborations, since its launch on the first International RSE Day on Thursday, 14th October 2021.
  
  - block: collection
    content:
      title: Latest News
      subtitle:
      text:
      count: 5
      filters:
        author: ''
        category: ''
        exclude_featured: false
        publication_type: ''
        tag: ''
      offset: 0
      order: desc
      page_type: post
    design:
      view: card
      columns: '1'
  
  - block: collection
    content:
      title: Latest Preprints
      text: ""
      count: 5
      filters:
        folders:
          - publication
        publication_type: 'article'
    design:
      view: citation
      columns: '1'

  - block: markdown
    content:
      title:
      subtitle:
      text: |
        {{% cta cta_link="./people/" cta_text="Meet the team →" %}}
    design:
      columns: '1'

  - block: markdown
    content:
      title: "Connect with us"
      subtitle: ""
      text: |
        <p align="center">
          <a href="https://github.com/rse-asia/RSE_Asia" target="_blank" title="GitHub">
            <i class="fab fa-github fa-2x" style="margin: 0 15px;"></i>
          </a>
          <a href="mailto:rse.asia.association@gmail.com" target="_blank" title="Email">
            <i class="fas fa-envelope fa-2x" style="margin: 0 15px;"></i>
          </a>
          <a href="https://www.linkedin.com/company/rse-asia-association/" target="_blank" title="LinkedIn">
            <i class="fab fa-linkedin fa-2x" style="margin: 0 15px;"></i>
          </a>        
        </p>
    design:
      background:
        color: "#ffffff"
        text_color_light: false
      spacing:
        padding: ["3rem", "1rem"]  
  
---
