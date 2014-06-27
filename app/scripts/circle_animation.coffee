#circle explosion
chart = '#chart__2'

setData = ->
 (((Math.random() * 400) for y in [1..2]) for x in [1..10])

data = setData()

shrink = ->
   clickedCircle = svg.selectAll 'circle'
   clickedCircle.data(data.slice(25))
     .transition()
     .duration 1000
     .attr "r", 10
     .each 'start', ->
       clickedCircle.style 'fill', '#39CA74'
     .each 'end', enlarge

enlarge = ->
 clickedCircle = svg.selectAll 'circle'
 clickedCircle.data(data.slice(0,25))
 .transition()
 .ease "elastic"
 .each 'start', ->
   clickedCircle.style 'fill', '#EF4545'
 .attr "r", 60
 .each 'end', place

place = ()->
 clickedCircle = svg.selectAll 'circle'
 data = setData()
 clickedCircle.data(data).enter()
   .transition()
    .delay 100
    .duration 500
    .attr "r", 35
    .attr "cx", (d) -> d[0]
    .attr 'cy', (d) -> d[1]
    .style "fill", "#36658F"

svg = d3.select chart
       .append 'svg'
       .attr 'height', '350px'
       .attr 'width', '900px'
       .attr 'background-color', 'grey'

svg
   .selectAll "circle"
   .data data
   .enter()
   .append "circle"
   .style "stroke", "#043D73"
   .style "fill", "#36658F"
   .attr "r", 40
   .attr "cx", 50
   .attr "cy", 50
   .on 'mousedown', enlarge
  .transition()
   .delay 100
   .duration 1000
   .attr "r", 30
   .attr "cx", (d) -> d[0] + 150
   .attr 'cy', (d) -> d[1]
   .style "fill", "#36658F"
  .transition()
   .delay 1000
   .ease "elastic"
   .style "fill", "#36658F"
   .each 'end', shrink
