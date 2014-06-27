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
