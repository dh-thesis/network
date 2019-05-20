sigma.parsers.json('../../data/mpis-ctx.json', {
    container: 'container',
    settings: {
        scalingMode: "outside",
        drawLabels: true,
        defaultLabelSize: 10,
        labelThreshold: 5,
        maxNodeSize: 2
    }
});
