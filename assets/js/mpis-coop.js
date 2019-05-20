sigma.parsers.json('../../data/mpis-coop.json', {
    container: 'container',
    settings: {
        scalingMode: "outside",
        drawLabels: true,
        defaultLabelSize: 10,
        labelThreshold: 5,
        maxNodeSize: 2
    }
});
