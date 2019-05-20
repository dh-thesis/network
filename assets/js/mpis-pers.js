sigma.parsers.json('../../data/mpis-pers.json', {
    container: 'container',
    settings: {
        scalingMode: "outside",
        drawLabels: true,
        defaultLabelSize: 10,
        labelThreshold: 100,
        maxNodeSize: 2
    }
});
