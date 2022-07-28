process INDEX {
    input:
    path transcriptome

    output:
    path 'salmon_index'

    script: 
    """
    salmon index --threads $task.cpus -t $transcriptome -i salmon_index
    """
}
