# obj constancy
chart = '#chart'
primaryColor = "#59E294"
secondaryColor = "#214592"

margin =
    top: 20
    right: 30
    bottom: 30
    left: 40

svgWidth = 960
svgHeight = 500

barPadding = 1

group1 = [1..4]
group2 = [4..7]
group3 = [7..10]

data = [group1, group2, group3]
dataMin = d3.min data, (d) -> d3.min d
dataMax = d3.max data, (d) -> d3.max d

xScale = d3.scale.linear()
    .range([0, svgWidth])

yScale = d3.scale.ordinal()
    .domain([0, 1, 2, 3])
    .rangeBands([0, svgHeight])

colorScale = d3.scale.linear()
            .domain([dataMin, dataMax])
            .range([primaryColor, secondaryColor])
            .interpolate(d3.interpolateHcl)

xAxis = d3.svg.axis()
    .scale xScale
    .orient "bottom"

svg = d3.select chart
    .append 'svg'
    .attr
        height: "#{ svgHeight + margin.top + margin.bottom }px"
        width: "#{ svgWidth + margin.left + margin.right }px"
    .style "margin-left", "#{-margin.left}px"
    .append "g"
    .attr "transform", "translate(#{margin.left}, #{margin.top})"

svg.append "g"
    .attr
        class: "x axis"
        transform: "translate(0, #{svgHeight})"
    .call xAxis

svg.append "g"
    .attr "class", "y axis"
  .append "line"
    .attr
        class: "domain"
        y2: svgHeight

draw = (data) ->

    dataMax = d3.max data
    xScale.domain([0, dataMax])

    svg
        .select ".x.axis"
        .transition()
        .delay 1000
        .duration 1000
        .call xAxis

    bar = svg.selectAll "rect"
        .data data

    barUpdate = bar
        .transition()
        .delay 1000
        .duration 1000
        .style
            stroke: "gray"
            fill: (d) -> colorScale(d)
        .attr
            x: barPadding
            y: (d, i) -> yScale(i)
            width: (d) -> xScale(d)
            height: -> yScale.rangeBand()

    barEnter = bar.enter()
        .append "rect"
        .style
            stroke: "white"
            fill: (d) -> colorScale(d)
        .attr
            x: barPadding
            y: (d, i) -> yScale(i)
            width: (d) -> xScale(d)
            height: -> yScale.rangeBand()

    barExit = bar.exit()
        .style "fill", "red"
        .transition()
        .delay 1000
        .duration 1000
        .style
            color: "red"
            "fill-opacity": 0
        .remove()


$ ->
    draw(data[0])

$ document
    .on "change", "#group", ->
        console.log "changing. Data:"
        console.log (data[$(@).val()])
        draw(data[$(@).val()])
