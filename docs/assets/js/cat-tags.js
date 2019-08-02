sigma.parsers.json('../../data/cat-tags.json', {
    container: 'container',
    settings: {
        scalingMode: "outside",
        drawLabels: true,
        defaultLabelSize: 10,
        labelThreshold: 7,
        maxNodeSize: 6
    }
});
