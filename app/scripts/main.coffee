# obj constancy
chart = '#chart__0'
primaryColor = "#59E294"
secondaryColor = "#214592"

margin =
    top: 20
    right: 30
    bottom: 30
    left: 40

svgWidth = 960 - margin.left - margin.right
svgHeight = 500 - margin.top - margin.bottom

barPadding = 1

group1 = [1..4]
group2 = [4..7]
group3 = [7..10]

data = [group1, group2, group3]
console.log data

dataMin = d3.min data, (d) -> d3.min d
dataMax = d3.max data, (d) -> d3.max d

xScale = d3.scale.linear()
    .range([0, svgWidth])
    .domain([0, dataMax])

yScale = d3.scale.ordinal()
    .domain([0, 1, 2, 3])
    .rangeRoundBands([0, svgHeight])

colorScale = d3.scale.linear()
            .domain([dataMin, dataMax])
            .range([primaryColor, secondaryColor])
            .interpolate(d3.interpolateHcl)

svg = d3.select chart
    .append 'svg'
    .attr 'height', "#{ svgHeight }px"
    .attr 'width', "#{ svgWidth }px"

placeBars = (data) ->


    barUpdate = svg.selectAll "rect"
        .data data
        .append "rect"
        .style "stroke", "gray"
        .attr
            fill: secondaryColor
            x: margin.left
            y: (d, i) -> yScale(i)
            width: (d) -> xScale(d)
            height: yScale.rangeBand()


    barEnter = svg.selectAll "rect"
        .data data
        .enter()
        .append "rect"
        .style "stroke", "gray"
        .attr
            fill: secondaryColor
            x: margin.left
            y: (d, i) -> yScale(i)
            width: (d) ->
              xScale(d)
            height: yScale.rangeBand()
        .on "mouseover", ->
            d3.select @
            .style "fill", primaryColor
        .on "mouseout", ->
            d3.select @
            .style "fill", secondaryColor

    barExit = svg.selectAll "rect"
        .data data
        .exit()
        .remove()


placeBars(data[0])

$ document
    .on "change", "#group", ->
        placeBars(data[$(@).val()])

# scatter plot
chart = '#chart__1'
primaryColor = "#59E294"
secondaryColor = "#214592"

margin =
  top: 20
  right: 30
  bottom: 30
  left: 40

svgWidth = 960 - margin.left - margin.right
svgHeight = 500 - margin.top - margin.bottom

data = ((Math.random() * 720 for x in [1..2]) for y in [1..25])
xMin = d3.min data, (d) -> d[0]
xMax = d3.max data, (d) -> d[0]
yMin = d3.min data, (d) -> d[1]
yMax = d3.max data, (d) -> d[1]

xScale = d3.scale.linear()
  .domain([xMin, xMax])
  .range([0, svgWidth])

yScale = d3.scale.linear()
  .domain([yMin, yMax])
  .range([svgHeight, 0])

colorScale = d3.scale.linear()
                 .domain([xMin, xMax])
                 .range([primaryColor, secondaryColor])
               .interpolate(d3.interpolateHcl)

svg = d3.select chart
        .append 'svg'
        .attr 'height', "#{ svgHeight }px"
        .attr 'width', "#{ svgWidth }px"

svg.selectAll "circle"
    .data data
    .enter()
    .append "circle"
    .style "stroke", "gray"
    .attr
      fill: (d) -> colorScale(d[0])
      r:  (d, i) -> i * 1.75
      cx: (d,i) -> xScale(d[0])
      cy: (d) -> yScale(d[1])
    .on "mouseover", ->
      d3.select @
      .style "fill", primaryColor
    .on "mouseout", ->
       d3.select @
        .style "fill", secondaryColor

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


