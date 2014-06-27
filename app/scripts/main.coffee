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

dataMin = d3.min data, (d) -> d3.min d
dataMax = d3.max data, (d) -> d3.max d


xScale = d3.scale.linear()
    .range([0, svgWidth])
    .domain([0, dataMax])

yScale = d3.scale.ordinal()
    .domain([0, 1, 2, 3])
    .rangeBands([0, svgHeight])

colorScale = d3.scale.linear()
            .domain([dataMin, dataMax])
            .range([primaryColor, secondaryColor])
            .interpolate(d3.interpolateHcl)

svg = d3.select chart
    .append 'svg'
    .attr 'height', "#{ svgHeight }px"
    .attr 'width', "#{ svgWidth }px"

placeBars = (data) ->

    bar = svg.selectAll "rect"
        .data data

    barEnter = bar.enter()
        .append "rect"
        .style
            stroke: "white"
            fill: secondaryColor
        .attr
            x: margin.left
            y: (d, i) -> yScale(i)
            width: (d) -> xScale(d)
            height: -> yScale.rangeBand()
        .on "mouseover", ->
            d3.select @
            .style "fill", primaryColor
        .on "mouseout", ->
            d3.select @
            .style "fill", secondaryColor

    barEnter.append "text"
        .attr
            class: "label"
            x: -3
            y: yScale.rangeBand() / 2
            dy: ".35em"
            "text-anchor": "end"
        .text (d) -> d

    barUpdate = bar.select "rect"
        .style "stroke", "gray"
        .attr
            fill: secondaryColor
            x: margin.left
            y: (d, i) -> yScale(i)
            width: (d) -> xScale(d)
            height: -> yScale.rangeBand()

    barExit = bar.exit()
        .remove()

$ ->
    # start app
    placeBars(data[0])

$ document
    .on "change", "#group", ->
        console.log "changing. Data:"
        console.log (data[$(@).val()])
        placeBars(data[$(@).val()])
