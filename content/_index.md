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

        Welcome to the website of the RSE Asia Association!
 
        All spaces of the RSE Asia Association are bound by the [code of conduct](https://society-rse.org/about/code-of-conduct/) of the [Society of Research Software Engineering](https://society-rse.org/). 
                

    design:
      background:
        color: "#ffffff"
        text_color_light: false
      spacing:
        padding: ["3rem", "1rem"]    

  - block: markdown
    content:
      title: Our Mentor Organisations
      text: |   

        <style>
          .logo-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 150px; /* Adjust as needed */
          }

          .logo-image {
            width: 180px !important;
            height: 180px !important;
            object-fit: contain;
          }
        </style>

        <div class="row justify-content-center mt-5">
          <div class="col-md-4 logo-container">
            <a href="https://we-are-ols.org/" target="_blank" title="OLS (Formely Open Life Science)">
              <img src="images/ols-transparent-bg.png" alt="OLS (Formely Open Life Science)" class="logo-image">
            </a>
          </div>
          <div class="col-md-4 logo-container">
            <a href="https://society-rse.org/" target="_blank" title="Society of Research Software Engineering">
              <img src="images/Soc_RSE_Logo.png" alt="Society of Research Software Engineering" class="logo-image">
            </a>
          </div>
         </div>
        </div>            
    design:
      background:
        color: "#ffffff"
        text_color_light: false      
      spacing:
        padding: ["3rem", "1rem"]  
        

  
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
